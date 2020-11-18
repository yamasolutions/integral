const { Plugin } = require('@uppy/core');
const cuid = require('cuid');
const Translator = require('@uppy/utils/lib/Translator');
const { Provider, Socket } = require('@uppy/companion-client');
const emitSocketProgress = require('@uppy/utils/lib/emitSocketProgress');
const getSocketHost = require('@uppy/utils/lib/getSocketHost');
const settle = require('@uppy/utils/lib/settle');
const limitPromises = require('@uppy/utils/lib/limitPromises');
const { DirectUpload } = require('@rails/activestorage');

class IntegralStorageFileUpload extends Plugin {
  constructor(uppy, opts) {
    super(uppy, opts);

    this.id = opts.id || 'ActiveStorageUpload';
    this.title = opts.title || 'ActiveStorageUpload';
    this.type = 'uploader';

    const defaultOptions = {
      limit: 0,
      timeout: 30 * 1000,
      directUploadUrl: null,
      integralFileUploadUrl: null,
      authenticityToken: null
    };

    this.opts = Object.assign({}, defaultOptions, opts);

    // Simultaneous upload limiting is shared across all uploads with this plugin.
    if (typeof this.opts.limit === 'number' && this.opts.limit !== 0) {
      this.limitUploads = limitPromises(this.opts.limit);
    } else {
      this.limitUploads = fn => fn;
    }

    this.handleUpload = this.handleUpload.bind(this);
  }

  install() {
    this.uppy.addUploader(this.handleUpload);
  }

  uninstall() {
    this.uppy.removeUploader(this.handleUpload);
  }

  handleUpload(fileIDs) {
    if (fileIDs.length === 0) {
      this.uppy.log('[ActiveStorage] No files to upload!');
      return Promise.resolve();
    }

    this.uppy.log('[ActiveStorage] Uploading...');
    const files = fileIDs.map(fileID => this.uppy.getFile(fileID));

    return this.uploadFiles(files).then(() => null);
  }

  upload(file, current, total) {
    this.uppy.log(`uploading ${current} of ${total}`);

    return new Promise((resolve, reject) => {
      const timer = this.createProgressTimeout(this.opts.timeout, error => {
        //xhr.abort();
        this.uppy.emit('upload-error', file, error);
        reject(error);
      });

      var directHandlers = {
        directUploadWillStoreFileWithXHR: null,
        directUploadDidProgress: null,
      };
      directHandlers.directUploadDidProgress = ev => {
        this.uppy.log(`[XHRUpload] ${id} progress: ${ev.loaded} / ${ev.total}`);
        timer.progress();

        if (ev.lengthComputable) {
          this.uppy.emit('upload-progress', file, {
            uploader: this,
            bytesUploaded: ev.loaded,
            bytesTotal: ev.total,
          });
        }
      };
      directHandlers.directUploadWillStoreFileWithXHR = request => {
        request.upload.addEventListener('progress', event =>
          directHandlers.directUploadDidProgress(event)
        );
      };

      const { data, meta } = file;

      if (!data.name && meta.name) {
        data.name = meta.name;
      }

      const upload = new DirectUpload(data, this.opts.directUploadUrl, directHandlers);
      const id = cuid();

      upload.create((error, blob) => {
        this.uppy.log(`[XHRUpload] ${id} finished`);
        timer.done();

        if (error) {
          // Put this duplication into a method
          const response = {
            status: 'error',
          };

          this.uppy.setFileState(file.id, { response });

          this.uppy.emit('upload-error', file, error);
          return reject(error);
        } else {
          /*
           * Create an Integral::Storage::File using the signedId of the uploaded Active Storage
           * blob along with the title and description the user provided
           */
          this.uppy.log('[Integral] Creating file...');
          let formData = new FormData()

          // TODO: Remove the file extension from name? If so should remove it initially
          formData.set('storage_file[title]', file.meta.name)
          formData.set('storage_file[description]', file.meta.description)
          formData.set('storage_file[attachment]', blob.signed_id)
          formData.set('authenticity_token', this.opts.authenticityToken)

          fetch(this.opts.integralFileUploadUrl, {
            method: 'POST',
            body: formData,
          }).then((response) => response.json())
          .then((data) => {
            const uppyResponse = {
              status: 'success',
              uploadURL: data.image,
              data
            };

            this.uppy.setFileState(file.id, { uppyResponse });
            this.uppy.emit('upload-success', file, uppyResponse);
            this.uppy.log('[Integral] Successfully created file.');
            return resolve(file);
          }).catch(function (error) {
            console.warn(error);
            const uppyResponse = {
              status: 'error',
            };

            this.uppy.setFileState(file.id, { uppyResponse });

            this.uppy.emit('upload-error', file, error);
            return reject(error);
          });
        }
      });

      this.uppy.on('file-removed', removedFile => {
        if (removedFile.id === file.id) {
          timer.done();
          upload.abort && upload.abort();
        }
      });

      this.uppy.on('upload-cancel', fileID => {
        if (fileID === file.id) {
          timer.done();
          upload.abort && upload.abort();
        }
      });

      this.uppy.on('cancel-all', () => {
        timer.done();
        upload.abort && upload.abort();
      });
    });
  }

  uploadFiles(files) {
    const actions = files.map((file, i) => {
      const current = parseInt(i, 10) + 1;
      const total = files.length;

      if (file.error) {
        return () => Promise.reject(new Error(file.error));
      } else {
        this.uppy.emit('upload-started', file);
        return this.upload.bind(this, file, current, total);
      }
    });

    const promises = actions.map(action => {
      const limitedAction = this.limitUploads(action);
      return limitedAction();
    });

    return settle(promises);
  }

  // Helper to abort upload requests if there has not been any progress for `timeout` ms.
  // Create an instance using `timer = createProgressTimeout(10000, onTimeout)`
  // Call `timer.progress()` to signal that there has been progress of any kind.
  // Call `timer.done()` when the upload has completed.
  createProgressTimeout(timeout, timeoutHandler) {
    const uppy = this.uppy;
    const self = this;
    let isDone = false;

    function onTimedOut() {
      uppy.log(`[XHRUpload] timed out`);
      const error = new Error(self.i18n('timedOut', { seconds: Math.ceil(timeout / 1000) }));
      timeoutHandler(error);
    }

    let aliveTimer = null;
    function progress() {
      // Some browsers fire another progress event when the upload is
      // cancelled, so we have to ignore progress after the timer was
      // told to stop.
      if (isDone) return;

      if (timeout > 0) {
        if (aliveTimer) clearTimeout(aliveTimer);
        aliveTimer = setTimeout(onTimedOut, timeout);
      }
    }

    function done() {
      uppy.log(`[XHRUpload] timer done`);
      if (aliveTimer) {
        clearTimeout(aliveTimer);
        aliveTimer = null;
      }
      isDone = true;
    }

    return {
      progress,
      done,
    };
  }
};

export default IntegralStorageFileUpload;
