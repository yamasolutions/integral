import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "subscribeForm", "unsubscribeForm", "list", "emptyMessage" ]

  unsubscribe(event) {
    if (event.detail.success) {
      this.subscribeFormTarget.classList.remove('d-none')
      this.unsubscribeFormTarget.classList.add('d-none')
    }
  }

  subscribe(event) {
    if (event.detail.success) {
      this.subscribeFormTarget.classList.add('d-none')
      this.unsubscribeFormTarget.classList.remove('d-none')
    }
  }
}
