import { Controller } from "stimulus"
import List from "utils/integral/list"

export default class extends Controller {
  connect() {
    new List(this.element)
  }
}
