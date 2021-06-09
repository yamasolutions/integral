import { Controller } from "stimulus"

// TODO: Cleanup
export default class extends Controller {
  connect() {
    if (this.element.dataset.loadMoreUrl) {
      window.lastNotificationObserver = new IntersectionObserver(this.loadMore, { root: this.element })
      window.lastNotificationObserver.observe(this.element.querySelector('ul li:last-of-type'))
    }

    window.unreadNotificationObserver = new IntersectionObserver(this.readNotification, { root: this.element, threshold: 0.90 });
    this.element.querySelectorAll('[data-notification-read-url]').forEach(element => window.unreadNotificationObserver.observe(element))
  }

  loadMore(entries) {
    const notificationsContainer = document.querySelector('.tab-pane-notifications')
    if (entries[0].intersectionRatio <= 0) {
      return;
    }

    window.lastNotificationObserver.unobserve(notificationsContainer.querySelector('ul li:last-of-type'))

    fetch(notificationsContainer.dataset.loadMoreUrl)
      .then(response => response.json())
      .then(json => {

        notificationsContainer.querySelector('ul').insertAdjacentHTML('beforeend', json.content)
        document.querySelectorAll('[data-notification-read-url]').forEach(notification => {
          window.unreadNotificationObserver.unobserve(notification)
          window.unreadNotificationObserver.observe(notification)
        })

        if (json.load_more_url) {
          notificationsContainer.dataset.loadMoreUrl = json.load_more_url
          window.lastNotificationObserver.observe(notificationsContainer.querySelector('ul li:last-of-type'))
        } else {
          notificationsContainer.querySelector('.js-loader--notifications').classList.add('d-none')
        }
      })
      .catch(error => {
        new Toast({ type: 'error', title: 'Unexpected Error', content: 'An error occurred. Please try again later.'})
      })
  }

  readNotification(entries) {
    var i;
    for (i = 0; i < entries.length; i++) {
      const entry = entries[i]

      if (entry.intersectionRatio < .90) {
        continue;
      }

      const readUrl = entry.target.dataset.notificationReadUrl
      window.unreadNotificationObserver.unobserve(entry.target)
      entry.target.removeAttribute('data-notification-read-url')

      fetch(readUrl, {
        method: 'PUT',
        headers: new Headers({'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content})
      })
    }
  }
}
