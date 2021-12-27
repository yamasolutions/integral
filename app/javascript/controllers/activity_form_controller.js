import { Controller } from "stimulus"

export default class extends Controller {
  submit(event) {
    event.preventDefault()

    fetch(this.element.action, {
      method: 'post',
      body: new URLSearchParams(new FormData(this.element))
    })
      .then(response => response.json())
      .then(json => {
        if (json.last_created_at != null) {
          this.element.closest('.modal').querySelector('[data-timeline]').insertAdjacentHTML('beforeend', json.content)
          this.element.querySelector("input[name='grid[created_at]']").value = json.last_created_at
        } else {
          this.element.querySelector("input[type='submit']").classList.add('d-none')
        }
      })
      .catch(error => {
        new Toast({ type: 'error', title: 'Unexpected Error', content: 'An error occurred. Please try again later.'})
      })
  }
}
