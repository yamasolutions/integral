import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"

export default class extends Controller {
  initialize() {
    let tagCreation = this.element.dataset.tagCreation
    if (tagCreation && tagCreation == 'false') {
      tagCreation = false
    } else {
      tagCreation = true
    }

    this.control = new tomSelect(this.element, {
      plugins: ['remove_button'],
      create: tagCreation,
      options: this.element.dataset.tagOptions.split(" ").map(obj => {
        return {
          value: obj,
          text: obj
        }
      })
    })
    this.control.on('type', (str) => {
      this.control.setTextboxValue(str.replace(/\s+/g, '-'))
    })
  }
  disconnect() {
    this.control.destroy()
  }
}
