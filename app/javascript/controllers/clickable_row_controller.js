import { Controller } from "stimulus"

export default class extends Controller {
  followLink(event) {
    if (!(event.target.type == 'button' || event.target.type == 'a')) {
      Turbo.visit(this.element.dataset.href)
    }
  }

  openDropdown(event) {
    event.preventDefault()
    this.element.querySelector('[data-bs-toggle]').click()
  }
}
