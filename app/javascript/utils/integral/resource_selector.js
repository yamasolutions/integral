const EventEmitter = require('events');

/**
 * Handles resource selection within Integral backend;
 * - Allows users to select a resource from a paginated list of resources.
 * - Pulls in the resources from a list endpoint.
 * - Grid format display, providing a search input field and a resource preview sidebar
 * - TODO: Allow multi-selection
 */
class ResourceSelector extends EventEmitter {
  constructor(title, url, opts) {
    super();
    this.title = title;
    this.url = url;

    const defaultOptions = {
      filters: {},
      allowMultiSelection: false,
      allowFileUpload: true,
      fileRestrictions: {
        maxNumberOfFiles: 1,
        allowedFileTypes: ['image/*']
      }
    };

    this.opts = Object.assign({}, defaultOptions, opts)

    // Create container from template
    this.container = document.querySelector('[data-resource-selector-template]').cloneNode(true)
    this.container.id = [...Array(30)].map(() => Math.random().toString(36)[2]).join('')
    this.container.removeAttribute('data-resource-selector-template')
    this.container.setAttribute('data-controller', 'resource-selector')
    this.container.setAttribute('data-resource-selector-url', url)
    this.container.setAttribute('data-resource-selector-default-filters', JSON.stringify(this.opts.filters))
    this.container.querySelector('h2').textContent = title
    if (this.opts.allowFileUpload) {
      this.container.querySelector("[data-target='resource-selector.uploadButton']").dataset.fileRestrictions = JSON.stringify(this.opts.fileRestrictions)
    } else {
      this.container.querySelector("[data-target='resource-selector.uploadButton'").remove()
    }

    // Append to body and initialize
    document.querySelector('body').appendChild(this.container)

    this.container.addEventListener("resources-selected", (event) => {
      this.emit('resources-selected', event.detail)
    });

    // window.jQuery(this.container).on("closed.zf.reveal", (event) => {
    //   this.emit('closed')
    // });
  }

  open() {
    new bootstrap.Modal(this.container).show()
    this.container.dispatchEvent(new CustomEvent('open'))
  }
};

window.ResourceSelector = ResourceSelector;
export default ResourceSelector;
