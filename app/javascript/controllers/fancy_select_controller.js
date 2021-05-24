import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  connect() {
    new tomSelect(this.element, {
      allowEmptyOption: true
    })
  }
}
