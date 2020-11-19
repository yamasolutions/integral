import { Controller } from "stimulus"

import ResourceSelector from 'utils/integral/resource_selector';

export default class extends Controller {
  static targets = [ "idField", "placeholderImage", "previewImage", "createActionsList", "addButton", "editActionsList", "removeButton", "editButton" ]

  connect() {
    this.resourceSelector = new ResourceSelector('Select Image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"))

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
    this.idFieldTarget.val = ''
    this.previewImageTarget.src = ''
    this.previewImageTarget.classList.add('hide')
    this.placeholderImageTarget.classList.remove('hide')
    this.createActionsListTarget.classList.remove('hide')
    this.editActionsListTarget.classList.add('hide')
  }

  updateImage(image) {
    this.idFieldTarget.value = image.id
    this.previewImageTarget.src = image.image
    this.previewImageTarget.classList.remove('hide')
    this.placeholderImageTarget.classList.add('hide')
    this.createActionsListTarget.classList.add('hide')
    this.editActionsListTarget.classList.remove('hide')
  }
}
