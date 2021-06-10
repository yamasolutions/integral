/**
 * Wrapper for ResourceSelector which Block Editor uses to upload & select media
 */
class BlockEditorMediaUploader {
  static open(callback) {
    // TODO: Possibly only create this instance once?
    const instance = new window.ResourceSelector('Select image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"), { filters: { type: 'image/%' } })
    instance.on('resources-selected', (event) => {
      const resource = event.resources[0]

      callback({
        id: parseInt(resource.id),
        title: resource.title,
        url: resource.image
      });
    });

    // TODO: Delay wouldn't be required if we instantiated on load
   setTimeout(() => { instance.open(); }, 200);
  }
};

export default BlockEditorMediaUploader;
