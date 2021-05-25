import Sortable from 'sortablejs'

class ListItem {
  constructor(form, wrapper) {
    this.form = form
    this.wrapper = wrapper
    this.container = this.wrapper.querySelector('.list-item')
    this.modal = document.querySelector(this.container.querySelector('.actions button').dataset.bsTarget)
    this.childrenAvailable = this.container.querySelector('.add-children a') != null
    this.titleText = this.container.querySelector('.data .title')
    this.urlText = this.container.querySelector('.data .url')
    this.urlField = this.modal.querySelector('.url-field')
    this.titleField = this.modal.querySelector('.title-field')
    this.targetField = this.modal.querySelector('.target-field')
    this.typeField = this.modal.querySelector('.type-field')
    this.imageField = this.modal.querySelector('.image-field')
    this.fakeTypeField = this.modal.querySelector('.faketype-field')
    this.objectTypeField = this.modal.querySelector('.object-type-field')
    this.objectIdField = this.modal.querySelector('.object-id-field')
    this.objectPreview = this.modal.querySelector('.object-preview')
    this.imagePreview = this.modal.querySelector('.image-preview img')
    this.objectWrapper = this.modal.querySelector('.object-wrapper')
    this.linkField = this.modal.querySelector('.link-field')
    this.linkNewTab = this.modal.querySelector('.link-new-tab')

    this.resourceSelectors = {}

    if (this.isObject()) {
      this.objectData = this.objectPreview.dataset
    }

    this.setIcon()
    this.setupEvents()
  }

  setupEvents() {
    if (this.childrenAvailable) {
      this.container.querySelector('.add-children a').addEventListener("click",  (event) => {
        this.expandChildren()
      })

      this.wrapper.querySelector('.children').addEventListener("cocoon:after-insert",  (event) => {
        this._handleListItemInsertion()
        this.setIcon()
      })

      this.wrapper.querySelector('.children').addEventListener("cocoon:after-remove",  (event) => {
        this.setIcon()
      })

      this.wrapper.querySelector('.children').addEventListener("cocoon:before-remove",  (event) => {
        bootstrap.Modal.getInstance(event.detail[0].querySelector('.modal')).hide()
      })
    }

    // Handle clicking of confirmation button within modal
    this.modal.querySelector('.confirm-btn').addEventListener("click",  (event) => {
      event.preventDefault()
      this._handleConfirmClick()
    })

    // Handle clicks on identifier button (sublist dropdown toggle)
    this.container.addEventListener("click",  (event) => {
      const selectors = ['identifier', 'action']

      if (selectors.every(i => Array.from(event.target.classList).includes(i))) {
        this._toggleChildren()
      }
    })

    this.objectPreview.addEventListener("click",  (event) => {
      this._createAndOpenSelector()
    })

    // Handle clicks on identifier button (sublist dropdown toggle)
    this.fakeTypeField.addEventListener("change",  (event) => {
      this.handleObjectUpdate()
    })
  }

  // Initalize drag and drop
  _initializeSortable() {
    this.form.querySelectorAll('.sortable').forEach(element => {
      var sortable = Sortable.create(element, {
        onUpdate: this._calculateListItemPriorities
      })
    })
  }

  _handleListItemInsertion() {
    const new_item = this._getChildren().querySelector('.list-item-container')
    const modal = new_item.querySelector('.modal')
    const modalTrigger = new_item.querySelector('.actions button')
    const modalId = `list-item-modal-${Date.now().toString()}`
    modal.setAttribute("id", modalId)
    modalTrigger.setAttribute("data-bs-target", `#${modalId}`)

    const list_item = new ListItem(this.form, new_item)
    this._initializeSortable()
    this.form.querySelectorAll('.list-item-container').forEach(function (element, priority) {
      element.querySelector('.priority-field').value = priority
    })
    list_item.openModal()

    console.log('handle insertion')
  }

  // Get element which contains children
  _getChildren() {
    return this.wrapper.querySelector('.children')
  }

  setIcon() {
    const identifier = this.container.querySelector('.identifier')
    let icon = 'link'
    let classes = ''

    if (this._hasChildren()) {
      if (this._getChildren().classList.contains('d-none')) {
        icon = 'chevron-down'
      } else {
        icon = 'chevron-up'
      }
      classes = 'action'
    } else {
      if (this.targetField.checked) {
        icon = 'globe'
      }
      if (this.isBasic()) {
        icon = 'list'
      }
      if (this.isObject()) {
        icon = this.objectIcon()
      }
    }

    identifier.className = ""
    identifier.classList.add('bi')
    identifier.classList.add('identifier')
    identifier.classList.add(`bi-${icon}`)
    if (classes != "") {
      identifier.classList.add(classes)
    }
  }

  objectIcon() {
    const icon = this.fakeTypeField.selectedOptions[0].dataset.icon
    if (icon) {
      return icon
    } else {
      return 'link'
    }
  }

  isBasic() {
    return this.typeField.value == 'Integral::Basic'
  }

  isObject() {
    return this.typeField.value == 'Integral::Object'
  }

  openModal() {
    new bootstrap.Modal(this.modal).show()
  }

  hideModal() {
    const instance = bootstrap.Modal.getInstance(this.modal)
    if (instance) {
      instance.hide()
    } else {
      new bootstrap.Modal(this.modal).hide()
    }
  }


  expandChildren() {
    this._getChildren().classList.remove('d-none')
    this.setIcon()
  }

  _hasChildren() {
    return this.wrapper.querySelector('.children .list-item-container') != null
  }


  // Handles when user clicks the ok button on modal
  _handleConfirmClick() {
    // Validate form before closing Modal
    console.log('validaton on confirm')
    // formValidator = $('#list_form').parsley
    //   successClass: ''
    //   errorClass: 'has-error'
    //   errorsWrapper: '<div class=\"parsley-error-block\"></div>'
    //   errorTemplate: '<span></span>'
    //   excluded: 'input:not(.reveal[aria-hidden=false] input)'
    //   classHandler: (element) =>
    //     element.$element.closest('.input-field')
    //
    // if formValidator.validate()
    //   @modal.foundation('close')
    //   sortable('.sortable', 'enable')
    //
    if (true) { // TODO: Add validation
      this._updateListItem()
      bootstrap.Modal.getInstance(this.modal).hide()
    } else {
      //toastr['error'](I18n.t('errors.fix_errors'))
    }
  }

  _updateListItem() {
    let title = ''
    let url = ''
    if (this.isObject()) {
      title = this.objectData.title
      url = this.objectData.url
    }
    if (this.titleField.value != '') {
      title = this.titleField.value
    }
    if (this.urlField.value != '') {
      url = this.urlField.value
    }

    this.titleText.textContent = title
    this.urlText.textContent = url
    this.setIcon()
  }

  // Toggle children element visibility
  _toggleChildren() {
    this._getChildren().classList.toggle('d-none')
    this.setIcon()
  }

  handleObjectUpdate() {
    this.typeField.value = this.fakeTypeField.selectedOptions[0].dataset.trueValue

    switch(this.typeField.value) {
      case 'Integral::Basic':
        this.handleBasicSelection()
        break;
      case 'Integral::Link':
        this.handleLinkSelection()
        break;
      case 'Integral::Object':
        this.handleObjectTypeSelection()
        break;
    }
  }

  handleBasicSelection() {
    this.objectWrapper.classList.add('d-none')
    this.linkField.classList.add('d-none')
    this.linkNewTab.classList.add('d-none')
    // this.titleField.addClass 'required'
  }

  handleLinkSelection() {
    this.objectWrapper.classList.add('d-none')
    this.linkField.classList.remove('d-none')
    this.linkNewTab.classList.remove('d-none')
    // this.titleField.classList.add 'required'
    //     @urlField.addClass 'required'
  }

  handleObjectTypeSelection() {
    this._createAndOpenSelector()
  }

  _createSelector(data) {
    const resourceSelector = new ResourceSelector(data.resourceSelectorTitle, data.resourceSelectorUrl, { allowFileUpload: false })

    resourceSelector.on('resources-selected', (event) => {
      this.handleObjectSelection(event.resources[0])
    })

    return resourceSelector
  }

  _createAndOpenSelector() {
    const currentSelection = this.fakeTypeField.selectedOptions[0].dataset
    if (this.resourceSelectors[currentSelection.objectType]) {
      this.resourceSelectors[currentSelection.objectType].open()
    } else {
      this.resourceSelectors[currentSelection.objectType] = this._createSelector(currentSelection)

      setTimeout(() => {
        // Timeout is necessary otherwise Stimulus has no time to instantiate controllers
        this.resourceSelectors[currentSelection.objectType].open()
      }, 200)
    }
  }

  handleObjectSelection(data) {
    this.objectTypeField.value = this.fakeTypeField.selectedOptions[0].dataset.objectType
    this.objectData = data

    // Update object preview
    this.objectIdField.value = data.id
    this.objectPreview.querySelector('img').setAttribute('src', data.image)
    this.objectPreview.querySelector('h5').textContent = data.title
    this.objectPreview.querySelector('.subtitle').textContent = data.subtitle
    this.objectPreview.querySelector('.url').textContent = data.url

    this.objectWrapper.classList.remove('d-none')
    this.linkField.classList.remove('d-none')
    this.linkNewTab.classList.remove('d-none')

    // # Update validation
    // @titleField.removeClass 'required'
    // @urlField.removeClass 'required'
    // @objectIdField.addClass 'required'
  }
}

export default ListItem;
