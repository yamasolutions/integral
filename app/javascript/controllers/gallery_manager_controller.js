import { Controller } from "stimulus"
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    const resourceSelectorOptions = {
      filters: { type: "image/%,video/%" },
      fileRestrictions: {
        maxNumberOfFiles: 1,
        allowedFileTypes: ["image/*", "video/*"]
      }
    }

    this.resourceSelector = new ResourceSelector('Select media..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"), resourceSelectorOptions)

    // Handle resource selection
    this.resourceSelector.on('resources-selected', (event) => {
      this.addItem(event.resources[0])
    })

    // Handle close when resource was not selected
    this.resourceSelector.on('closed', (event) => {
      const lastElement = Array.from(this.containerTarget.querySelectorAll('.gallery-manager--item-wrapper')).pop()
      if (lastElement.querySelector("[data-target='gallery-manager-item.objectField']").value == '') {
        lastElement.remove()
      }
    })

    this.containerTarget.addEventListener("cocoon:after-insert",  (event) => {
      this.resourceSelector.open()
    })

    Sortable.create(this.containerTarget, {
      onUpdate: () => {
        this.updateSortOrder()
      },
      items: '.gallery-manager--item-wrapper'
    })
  }

  addItem(item) {
    this.containerTarget.lastElementChild.dispatchEvent(new CustomEvent('populate', { detail: item }))
    this.resort()
  }

  resort() {
    Sortable.create(this.containerTarget, {
      onUpdate: this.updateSortOrder,
      items: '.gallery-manager--item-wrapper'
    })
    this.updateSortOrder()
  }

  updateSortOrder() {
    this.containerTarget.querySelectorAll('.gallery-manager--item-wrapper').forEach(function (element, priority) {
      element.querySelector("[data-target='gallery-manager-item.priorityField']").value = priority
    });
  }
}
