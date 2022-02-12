import { Controller } from "stimulus"
import tomSelect from "tom-select/dist/js/tom-select.complete"
import Sortable from 'sortablejs'

// All this seems overcomplicated - the functionality is basically a pillbox with custom templating
export default class extends Controller {
  static targets = [ "dropdown", "template", "list", "emptyMessage" ]

  connect() {
    this.listTarget.querySelectorAll(':scope > .alternate-resource').forEach(function (resource) {
      resource.classList.add('editable')
    })

    this.selector = new tomSelect(this.dropdownTarget)


    Sortable.create(this.listTarget, {
      onUpdate: () => {
        this.updateSortOrder()
      },
      items: '.alternate-resource'
    })
  }

  updateSortOrder() {
    this.listTarget.querySelectorAll('.editable').forEach(function (element, priority) {
      var priorityInput = Array.from(element.querySelectorAll('input')).find(function (item) {
        return item.name.endsWith("priority]")
      })
      element.querySelector("[data-target='gallery-manager-item.priorityField']").value = priority
      priorityInput.value = priority
    })
  }

  add() {
    this.listTarget.insertAdjacentHTML('beforeend', this.templateTarget.innerHTML)
    var alternateResourceCard = Array.from(this.listTarget.querySelectorAll('.alternate-resource')).pop()
    var selectedOption = this.dropdownTarget.selectedOptions[0]
    var selectedOptionData = selectedOption.dataset
    var idInput = Array.from(alternateResourceCard.querySelectorAll('input')).find(function (item) {
      return item.name.endsWith("_id]")
    })

    idInput.value = selectedOption.value
    alternateResourceCard.querySelector('.alternate-resource--title span').innerHTML = selectedOptionData.title
    alternateResourceCard.querySelector('.alternate-resource--title a').href = selectedOptionData.url
    alternateResourceCard.querySelector('.alternate-resource--description').innerHTML = selectedOptionData.description
    alternateResourceCard.querySelector('.alternate-resource--path').innerHTML = selectedOptionData.path

    alternateResourceCard.classList.add('editable')
    this.selector.destroy()
    Array.from(this.dropdownTarget.options).forEach(item => {
      if (item.value == selectedOption.value) {
        item.disabled = true
      }
    })

    this.selector = new tomSelect(this.dropdownTarget)
    this.toggleEmptyMessage()
  }

  remove() {
    var wrapper = event.target.closest('.alternate-resource')
    var alternateId = Array.from(wrapper.querySelectorAll('input')).find(function (item) {
      return item.name.endsWith("_id]")
    }).value

    Array.from(wrapper.querySelectorAll("input")).find(function (item) {
      return item.name.endsWith("destroy]")
    }).value = "true"

    wrapper.classList.add("d-none")
    this.selector.destroy()

    Array.from(this.dropdownTarget.options).find(function (item) {
      return item.value == alternateId
    }).disabled = false

    this.selector = new tomSelect(this.dropdownTarget)
    this.toggleEmptyMessage()
  }

  toggleEmptyMessage() {
    if (this.listTarget.querySelectorAll('.alternate-resource').length == 1) {
      this.emptyMessageTarget.classList.remove('d-none')
    } else {
      this.emptyMessageTarget.classList.add('d-none')
    }
  }

  disconnect() {
    this.selector.destroy()
  }
}
