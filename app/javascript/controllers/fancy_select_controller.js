import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  connect() {
    this.control = new tomSelect(this.element, {
      plugins: ['remove_button'],
      allowEmptyOption: true
    })
  }

  disconnect() {
    this.control.destroy()
  }
}
