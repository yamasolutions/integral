import { Controller } from "stimulus"

export default class extends Controller {
  openModal(event) {
    const modal = document.getElementById(this.element.dataset.containerId)

    if (modal) {
      bootstrap.Modal.getInstance(modal).show()
    } else {
      const modal = document.getElementById('activity-placeholder').cloneNode(true)
      const form = modal.querySelector('form')
      modal.id = this.element.dataset.containerId

      // Populate modal with content & filters
      modal.querySelector('[data-title]').innerHTML = this.element.dataset.recentActivityTitle
      modal.querySelector('[data-timeline]').innerHTML = this.element.closest('.card').querySelector('.timeline').innerHTML
      form.querySelector("input[name='grid[user]']").value = this.element.dataset.recentActivityUser || ''
      form.querySelector("input[name='grid[object]']").value = this.element.dataset.recentActivityObject || ''
      form.querySelector("input[name='grid[created_at]']").value = this.element.dataset.recentActivityCreatedAt || ''
      form.querySelector("input[name='grid[item_id]']").value = this.element.dataset.recentActivityItemId || ''
      document.querySelector('body').insertAdjacentHTML('beforeend', modal)

      new bootstrap.Modal(modal).show()

      setTimeout(() => {
        // Timeout is necessary otherwise Stimulus has no time to instantiate controllers
        form.requestSubmit()
      }, 200)
    }
  }
}
