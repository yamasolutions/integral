import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  initialize() {
    const control = new tomSelect(this.element, {
      plugins: ['remove_button'],
      create: true,
      options: this.element.dataset.tagOptions.split(" ").map(obj => {
        return {
          value: obj,
          text: obj
        }
      })
    })
    control.on('type', (str) => {
      control.setTextboxValue(str.replace(/\s+/g, '-'))
    })
  }
}
