import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "priorityField", "objectField", "image" ]

  populate() {
    this.imageTarget.src = event.detail.image
    this.objectFieldTarget.value = event.detail.id
  }
}
