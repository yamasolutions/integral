import { Controller } from "stimulus"

export default class extends Controller {
  confirmUnique(event) {
    if (this.element.checked) {
      event.target.closest('tr').querySelectorAll('input[type=checkbox]').forEach(element => {
        // debugger
        if (element != this.element) {
          element.checked = false
        }
      })
    }
  }
}
