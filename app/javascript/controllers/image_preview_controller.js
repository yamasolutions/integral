import { Controller } from "stimulus"

import ResourceSelector from 'utils/integral/resource_selector';

export default class extends Controller {
  static targets = [ "idField", "placeholderImage", "previewImage", "createActionsList", "addButton", "editActionsList", "removeButton", "editButton" ]

  connect() {
    this.resourceSelector = new ResourceSelector('Select Image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"), { filters: { type: 'image/%' } })

    this.resourceSelector.on('resources-selected', (event) => {
      this.updateImage(event.resources[0])
    })
  }

  add() {
    this.resourceSelector.open()
  }

  edit() {
    this.resourceSelector.open()
  }

  remove() {
    this.idFieldTarget.value = ''
    this.previewImageTarget.src = ''
    this.previewImageTarget.classList.add('d-none')
    this.placeholderImageTarget.classList.remove('d-none')
    this.createActionsListTarget.classList.remove('d-none')
    this.editActionsListTarget.classList.add('d-none')
  }

  updateImage(image) {
    this.idFieldTarget.value = image.id
    this.previewImageTarget.src = image.image
    this.previewImageTarget.classList.remove('d-none')
    this.placeholderImageTarget.classList.add('d-none')
    this.createActionsListTarget.classList.add('d-none')
    this.editActionsListTarget.classList.remove('d-none')
  }
}
