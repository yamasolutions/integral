import { Controller } from "stimulus"

export default class extends Controller {
  disableButton() {
    this.element.querySelector("input[type='submit']").disabled = true
  }

  enableButton() {
    this.element.querySelector("input[type='submit']").disabled = false
  }

  displayErrorToast() {
    if (!event.detail.success) {
      // new Toast({ type: 'error', title: 'Unexpected Error', content: I18n.t('integral.remote_form.error')})
      new Toast({ type: 'error', title: 'Unexpected Error', content: 'An error occurred. Please try again later'})
    }
  }

  displayToast() {
    if (event.detail.success) {
      new Toast({ type: 'primary', title: 'Success', content: this.successMessage})
    } else {
      new Toast({ type: 'error', title: 'Unexpected Error', content: I18n.t('integral.remote_form.error')})
    }
  }

  resetOnSuccess() {
    if (event.detail.success) {
      this.element.reset()
    }
  }

  redirectOnSuccess(event) {
    if (event.detail.success) {
      event.detail.fetchResponse.response.json().then(data => {
        Turbo.visit(data.redirect_url)
      })
    }
  }

  pushEvent() {
    const customEvent = this.element.dataset.remoteFormEvent

    if (event.detail.success && customEvent) {
      window.dataLayer = window.dataLayer || []
      dataLayer.push({ 'event': customEvent })
    }
  }

  get successMessage() {
    const customMessage = this.element.dataset.remoteFormSuccessMessage
    if (customMessage) {
      return customMessage
    } else {
      // return I18n.t('integral.remote_form.success')
      return "Your request was complete successfully."
    }
  }
}
