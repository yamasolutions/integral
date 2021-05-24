import { Controller } from "stimulus"
import Grid from "utils/integral/grid"

export default class extends Controller {
  connect() {
    new Grid(this.element)
  }
}
