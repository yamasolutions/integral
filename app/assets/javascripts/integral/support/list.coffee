class this.List
  # List constructor
  constructor: ->
    @listItemContainer = $('.list-item-container')
    @listItemLimit = $('#list_form').data('list-item-limit')
    @_createListItems()
    @_initializeSortable()
    @_setupEvents()

    @_setupForm()

  _setupEvents: ->
    $('.sortable').each (sortable_index, sortable_element) =>
      sortable_element.addEventListener 'sortupdate', =>
        @_calculateListItemPriorities()

    # Handle new ListItem Insertion & Removal
    $('#list-items')
      .on 'cocoon:before-insert', (e, new_item) =>
        if @listItemLimit > 0 && $('.list-item-container:visible').length >= @listItemLimit
          e.preventDefault()
          toastr['error']("This list is limited to #{@listItemLimit} list items.")
      .on 'cocoon:after-insert', (e, new_item) =>
        @_handleListItemInsertion(new_item)

      .on 'cocoon:before-remove', (e, removed_item) =>
        @_calculateListItemPriorities()

    # Do not allow submit on enter
    $('form').on 'keyup keypress', (e) =>
      keyCode = e.keyCode or e.which
      if keyCode == 13
        e.preventDefault()
        inputId = e.target.id

        if inputId == 'list_description' or inputId == 'list_title'
          @_hideListField(e.target)

  _setupForm: ->

  # Initalize drag and drop
  _initializeSortable: ->
    sortable '.sortable',
      items: '.list-item-container'

  # Create List Item objects
  _createListItems: ->
    @listItemContainer.each (i, itemContainer) =>
      new ListItem(@, itemContainer)

  # Calculate & set list item priorities
  _calculateListItemPriorities: ->
    $('.list-item-container').each (priority, itemContainer) =>
      $(itemContainer).find('.priority-field').val(priority)

  # Initializes new List Item
  _handleListItemInsertion: (new_item) ->
    # Create connection to modal
    modal = new_item.find('.reveal')
    modalTrigger = new_item.find('.modal-trigger')
    modal.attr("id","list-item-modal-#{$.now()}")
    modalTrigger.attr("data-open","list-item-modal-#{$.now()}")

    # Initialize new ListItem
    list_item = new ListItem(@, new_item)
    modal.foundation()
    modal.find('input, textarea').characterCounter()

    @_initializeSortable()
    @_calculateListItemPriorities()

    list_item.openModal()
