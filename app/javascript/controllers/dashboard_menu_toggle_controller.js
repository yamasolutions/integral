import { Controller } from "stimulus"

export default class extends Controller {
  toggle() {
    if (window.localStorage.getItem('integral-sidebar') == 'shrunk') {
      window.localStorage.setItem('integral-sidebar', 'large')
      document.querySelector('.app-dashboard').classList.add('shrink-medium')
      document.querySelector('.app-dashboard').classList.remove('shrink-large')
    } else {
      window.localStorage.setItem('integral-sidebar', 'shrunk')
      document.querySelector('.app-dashboard').classList.remove('shrink-medium')
      document.querySelector('.app-dashboard').classList.add('shrink-large')
    }
  }
}
