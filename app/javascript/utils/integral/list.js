import ListItem from 'utils/integral/list_item';
import Sortable from 'sortablejs';

class List {
  constructor(form) {
    this.form = form
    this.listItemLimit = this.form.dataset.listItemLimit
    this.addButton = this.form.querySelector('#top-add-list-button')

    this._createListItems()
    this._initializeSortable()
    this._setupEvents()
  }

  _setupEvents() {
    this.addButton.addEventListener("cocoon:before-insert",  (event) => {
      if (this.listItemLimit > 0 && this.form.querySelectorAll('#list-items > .list-item-container').length >= this.listItemLimit) {
        event.preventDefault()
        // toastr['error']("This list is limited to #{@listItemLimit} list items.")
        console.error(`This list is limited to ${this.listItemLimit} list items.`)
        return false
      }
    })

    this.addButton.addEventListener("cocoon:after-insert",  (event) => {
      this._handleListItemInsertion()
    })

    this.form.querySelector('#list-items').addEventListener("cocoon:before-remove",  (event) => {
      bootstrap.Modal.getInstance(event.detail[0].querySelector('.modal')).hide()
    })

    //     # Do not allow submit on enter
    //     $('form').on 'keyup keypress', (e) =>
    //       keyCode = e.keyCode or e.which
    //       if keyCode == 13
    //         e.preventDefault()
    //         inputId = e.target.id
    //
    //         if inputId == 'list_description' or inputId == 'list_title'
    //           @_hideListField(e.target)
  }

  _createListItems() {
    this.form.querySelectorAll('.list-item-container').forEach(element => new ListItem(this.form, element))
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
    const new_item = this.form.querySelector('#list-items .list-item-container')
    const modal = new_item.querySelector('.modal')
    const modalTrigger = new_item.querySelector('.actions button')
    const modalId = `list-item-modal-${Date.now().toString()}`
    const childrenId = `list-item-children-${Date.now().toString()}`
    modal.setAttribute("id", modalId)
    modalTrigger.setAttribute("data-bs-target", `#${modalId}`)

    new_item.querySelector('.children').setAttribute("id", childrenId)
    new_item.querySelector('.add-children a').setAttribute("data-association-insertion-node", `#${childrenId}`)

    const list_item = new ListItem(this.form, new_item)
    this._initializeSortable()
    this.form.querySelectorAll('.list-item-container').forEach(function (element, priority) {
      element.querySelector('.priority-field').value = priority
    })
    list_item.openModal()

    console.log('handle insertion')
  }

  // Calculate & set list item priorities
  _calculateListItemPriorities(event) {
    event.from.querySelectorAll('.list-item-container').forEach(function (element, priority) {
      element.querySelector('.priority-field').value = priority
    })
  }
}

export default List;
