import { Controller } from "stimulus"

export default class extends Controller {
  toggle() {
    if (document.cookie.includes("shrunk")) {
      document.cookie = 'integral-sidebar=large';
      document.querySelector('.app-dashboard').classList.add('shrink-medium')
      document.querySelector('.app-dashboard').classList.remove('shrink-large')
    } else {
      document.cookie = 'integral-sidebar=shrunk';
      document.querySelector('.app-dashboard').classList.remove('shrink-medium')
      document.querySelector('.app-dashboard').classList.add('shrink-large')
    }
  }
}
