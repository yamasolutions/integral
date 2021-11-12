/**
 * Wrapper for ResourceSelector which Block Editor uses to upload & select media
 */
class BlockEditorMediaUploader {
  static open(callback, props) {
    let allowedTypes = props.type
    if (!Array.isArray(allowedTypes)) {
      allowedTypes = [props.type]
    }
    const resourceSelectorOptions = {
      filters: { type: allowedTypes.map( type => { return `${type}/%` }).join(",") },
      fileRestrictions: {
        maxNumberOfFiles: 1,
        allowedFileTypes: allowedTypes.map( type => { return `${type}/*` })
      }
    }

    const instance = new window.ResourceSelector('Select media..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"), resourceSelectorOptions)
    instance.on('resources-selected', (event) => {
      // TODO: This needs to support returning things other than images, such as videos
      // Possibly instead of image we call .asset or .url and image could change to preview?
      const selectedResource = event.resources[0]
      callback({
        url: selectedResource.image,
        id: parseInt(selectedResource.id)
      });
    });

    // TODO: Delay wouldn't be required if we instantiated on load
   setTimeout(() => { instance.open(); }, 200);
  }
};

export default BlockEditorMediaUploader;
