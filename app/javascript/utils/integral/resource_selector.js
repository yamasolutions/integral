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
      allowFileUpload: false,
      fileRestrictions: {}
    };

    this.opts = Object.assign({}, defaultOptions, opts);

    // Create container from template
    this.container = document.querySelector('[data-resource-selector-template]').cloneNode(true);
    this.container.removeAttribute('data-resource-selector-template');
    this.container.setAttribute('data-controller', 'resource-selector');
    this.container.setAttribute('data-resource-selector-url', url);
    this.container.querySelector('h2').textContent = title;

    document.querySelector('body').appendChild(this.container);

    window.jQuery(this.container).foundation();

    this.container.addEventListener("resources-selected", (event) => {
      this.emit('resources-selected', event.detail)
    });

  }

  open() {
    window.jQuery(this.container).foundation('open');
    this.container.dispatchEvent(new CustomEvent('open'));
  }
};

export default ResourceSelector;
