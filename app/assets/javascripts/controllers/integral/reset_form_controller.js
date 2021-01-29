import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log('INTEGRAL Form reset using stimulu1s')
    this.element.reset()
  }
}
