import { Controller } from "stimulus"

export default class extends Controller {
  confirm() {
    const modal = document.querySelector('#modal-confirm').cloneNode(true)
    modal.id = [...Array(30)].map(() => Math.random().toString(36)[2]).join('')
    modal.querySelector('.modal-body p').innerHTML = this.element.dataset.message
    modal.querySelector('.btn-primary').addEventListener('click', () => {
      fetch(this.element.dataset.href, {
        method: this.element.dataset.method?.toUpperCase() || 'GET',
        headers: new Headers({'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content})
      })
        .then(response => {
          if (response.redirected) {
            Turbo.visit(response.url)
          }
        })
      modal.querySelector('.btn-close').click()
    })
    document.querySelector('body').appendChild(modal)
    new bootstrap.Modal(modal).show()
  }
}
