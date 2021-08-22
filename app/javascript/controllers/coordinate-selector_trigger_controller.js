import { Controller } from "stimulus"

export default class extends Controller {
  open() {
    window.coordinateSelectorWrapper = this.element.dataset.wrapper || ''
    const instance = bootstrap.Modal.getInstance(document.getElementById('modal-coordinate-selector'))
    if (instance) {
      instance.show()
    } else {
      new bootstrap.Modal(document.getElementById('modal-coordinate-selector')).show()
    }
  }
}
