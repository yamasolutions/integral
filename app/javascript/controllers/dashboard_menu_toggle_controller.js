import { Controller } from "stimulus"

export default class extends Controller {
  toggle() {
    if (this.getCookie('integral-sidebar') == "shrunk") {
      this.setCookie("integral-sidebar", "large")
      document.querySelector('.app-dashboard').classList.add('shrink-medium')
      document.querySelector('.app-dashboard').classList.remove('shrink-large')
    } else {
      this.setCookie("integral-sidebar", "shrunk")
      document.querySelector('.app-dashboard').classList.remove('shrink-medium')
      document.querySelector('.app-dashboard').classList.add('shrink-large')
    }
  }

  setCookie(cname, cvalue, exdays=1000) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
  }

  getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
    }
    return "";
  }
}
