import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "priorityField", "imageField", "image" ]

  populate() {
    this.imageTarget.src = event.detail.image
    this.imageFieldTarget.value = event.detail.id
  }
}
