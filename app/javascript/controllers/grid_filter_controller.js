import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  initialize() {
    this.control = new tomSelect(this.element, {
      plugins: ['remove_button']
    })
  }

  disconnect() {
    this.control.destroy()
  }
}
