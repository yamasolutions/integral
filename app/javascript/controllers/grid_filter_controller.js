import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  initialize() {
    new tomSelect(this.element, {
      plugins: ['remove_button']
    })
  }
}
