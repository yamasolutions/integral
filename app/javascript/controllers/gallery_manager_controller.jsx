import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    this.resourceSelector = new ResourceSelector('Select Image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"), { filters: { type: 'image/%' } })

    // Handle resource selection
    this.resourceSelector.on('resources-selected', (event) => {
      this.addItem(event.resources[0])
    })

    // Handle close when resource was not selected
    this.resourceSelector.on('closed', (event) => {
      if (this.containerTarget.lastElementChild.querySelector("[data-target='gallery-manager-item.objectField']").value == '') {
        this.containerTarget.lastElementChild.remove()
      }
    })

    $(this.containerTarget).on('cocoon:after-insert', (e, new_item) => {
      this.resourceSelector.open()
    })

    $(this.containerTarget).on( "sortupdate", () => {
      this.updateSortOrder()
    })

    sortable(this.containerTarget, {items: '.gallery-manager--item-wrapper' })
  }

  addItem(item) {
    this.containerTarget.lastElementChild.dispatchEvent(new CustomEvent('populate', { detail: item }))
    this.resort()
  }

  resort() {
    sortable(this.containerTarget, {items: '.gallery-manager--item-wrapper' })
    this.updateSortOrder()
  }

  updateSortOrder() {
    this.containerTarget.querySelectorAll('.gallery-manager--item-wrapper').forEach(function (element, priority) {
      element.querySelector("[data-target='gallery-manager-item.priorityField']").value = priority
    });
  }
}
