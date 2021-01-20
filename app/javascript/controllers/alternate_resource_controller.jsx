import { Controller } from "stimulus"
import $ from 'jquery'
import 'select2'

// All this seems overcomplicated - the functionality is basically a pillbox with custom templating
export default class extends Controller {
  static targets = [ "dropdown", "template", "list", "emptyMessage" ]

  connect() {
    _.each(this.listTarget.querySelectorAll(':scope > .alternate-resource'), function(resource){ resource.classList.add('editable'); })

    $(this.dropdownTarget).select2({
      placeholder: 'Select an alternate..',
      allowClear: true
    })

    $(this.dropdownTarget).on('change.select2', (event) => {
      if (this.dropdownTarget.value != '') {
        this.add(event)
      }
    })
  }

  add() {
    this.listTarget.insertAdjacentHTML('beforeend', this.templateTarget.innerHTML)
    var alternateResourceCard = Array.from(this.listTarget.querySelectorAll('.alternate-resource')).pop()
    var selectedOption = this.dropdownTarget.selectedOptions[0]
    var selectedOptionData = selectedOption.dataset

    _.first(alternateResourceCard.querySelectorAll('input')).value = selectedOption.value
    _.first(alternateResourceCard.querySelectorAll('.alternate-resource--title span')).innerHTML = selectedOptionData.title
    _.first(alternateResourceCard.querySelectorAll('.alternate-resource--title a')).href = selectedOptionData.url
    _.first(alternateResourceCard.querySelectorAll('.alternate-resource--description')).innerHTML = selectedOptionData.description
    _.first(alternateResourceCard.querySelectorAll('.alternate-resource--path')).innerHTML = selectedOptionData.path

    alternateResourceCard.classList.add('editable')
    $(this.dropdownTarget).val(null).trigger('change')
    selectedOption.disabled = true
    this.toggleEmptyMessage()
  }

  remove() {
    var wrapper = event.target.closest('.alternate-resource')
    var alternateId = Array.from(wrapper.querySelectorAll('input')).pop().value

    wrapper.remove()

    _.find(this.dropdownTarget.options, function(option){ return option.value == alternateId; }).disabled = false

    this.toggleEmptyMessage()
  }

  toggleEmptyMessage() {
    if (this.listTarget.querySelectorAll('.alternate-resource').length == 1) {
      this.emptyMessageTarget.classList.remove('hide')
    } else {
      this.emptyMessageTarget.classList.add('hide')
    }
  }
}
