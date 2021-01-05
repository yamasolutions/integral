import { Controller } from "stimulus"

import Choices from "choices.js"

export default class extends Controller {
  initialize() {
    this.choices = new Choices(this.element, {
      removeItemButton: true,
      // renderSelectedChoices: 'always'
    })
  }

  hideDropdown() {
    this.choices.hideDropdown()
  }
}
