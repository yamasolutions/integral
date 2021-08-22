import { Controller } from "stimulus"
import Sortable from 'sortablejs'

export default class extends Controller {
  connect() {
    new Sortable(this.element, {
      onSort: function(evt) {
        Array.from(evt.target.children).forEach(function (element, priority) {
          element.querySelector('input').value = priority
        })
      }
    })
  }
}
