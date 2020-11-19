class this.ListItem
  # ListItem constructor
  constructor: (list, container) ->
    @list = list
    @outerContainer = $(container)
    @container = @outerContainer.find('.list-item:first')
    if @container.data('persisted')
      @modal = $("##{@container.find('.modal-trigger').data('open')}")
    else
      @modal = @container.find('.reveal')
    @titleText = @container.find('.data .title')
    @urlText = @container.find('.data .url')
    @urlField = @modal.find('.url-field')
    @titleField = @modal.find('.title-field')
    @targetField = @modal.find('.target-field')
    @typeField = @modal.find('.type-field')
    @imageField = @modal.find('.image-field')
    @fakeTypeField = @modal.find('.faketype-field')
    @objectTypeField = @modal.find('.object-type-field')
    @objectIdField = @modal.find('.object-id-field')
    @objectPreview = @modal.find('.object-preview')
    @imagePreview = @modal.find('.image-preview img')
    @objectWrapper = @modal.find('.object-wrapper')
    @linkAttribute = @modal.find('.link-attribute')
    @unlinkButton = @modal.find('.unlink-btn')
    @resourceSelectors = {}

    if @object()
      @objectData = @objectPreview.data()

    if !@imageField.data().imagePresent
      @unlinkButton.hide()

    @setIcon()
    @setupEvents()

  setupEvents: ->
    @outerContainer.on 'modal-close', =>
      sortable('.sortable', 'enable')

    # # Initialize modal trigger
    # @container.find('.modal-trigger').leanModal(@_modalOptions())

    # Set children list items to be inserted in correct location
    @container.find('.add-children a').data "association-insertion-node", (link) =>
      @outerContainer.find('.children')

    @container.find('.add-children a').click =>
      @expandChildren()

    # Handle clicking of confirmation button within modal
    @modal.find('.confirm-btn').click (e) =>
      e.preventDefault()
      @_handleConfirmClick()

    # Handle clicking of remove button within modal
    @modal.find('a.modal-close').click (e) =>
      @modal.foundation('close')

    # Handle clicks on identifier button (sublist dropdown toggle)
    @container.on 'click', '.identifier.action', =>
      @_toggleChildren()

    # Handle new ListItem Insertion & Removal
    @outerContainer.on 'cocoon:after-insert', '.children', =>
      @setIcon()
    @outerContainer.on 'cocoon:after-remove', '.children', =>
      @setIcon()
    @modal.find('.remove_fields').on 'click', =>
      @container.detach()
    @modal.find('.remove_fields.dynamic').on 'click', =>
      @modal.detach()
      @outerContainer.detach()

    @fakeTypeField.change (e) =>
      @handleObjectUpdate()

    @objectPreview.click =>
      @_createAndOpenSelector()

    @imagePreview.click =>
      @_createAndOpenImageSelector()

    @unlinkButton.click (ev) =>
      ev.preventDefault()
      @imageField.val('')
      @imagePreview.attr('src', @imageField.data().fallbackImage)
      @unlinkButton.hide()

  handleObjectUpdate: ->
    @typeField.val @fakeTypeField.find(':selected').data('true-value')
    switch @typeField.val()
      when 'Integral::Basic' then @handleBasicSelection()
      when 'Integral::Link' then @handleLinkSelection()
      when 'Integral::Object' then @handleObjectTypeSelection()

  handleBasicSelection: ->
    @objectWrapper.addClass 'hide'
    @linkAttribute.addClass 'hide'
    @titleField.addClass 'required'

  handleLinkSelection: ->
    @objectWrapper.addClass 'hide'
    @linkAttribute.removeClass 'hide'

    @titleField.addClass 'required'
    @urlField.addClass 'required'

  handleObjectTypeSelection: ->
    @_createAndOpenSelector()

  handleObjectSelectionFail: =>
    @fakeTypeField.val('Integral::Basic')

  handleImageSelection: (data) =>
    @imageField.val(data.id)
    @imagePreview.attr('src', data.image)
    @unlinkButton.show()

  handleObjectSelection: (data) =>
    @objectTypeField.val(@fakeTypeField.find(":selected").data('object-type'))
    @objectData = data

    # Update object preview
    @objectIdField.val(data.id)
    @objectPreview.find('img').attr('src', data.image)
    @objectPreview.find('h5').text(data.title)
    @objectPreview.find('.subtitle').text(data.subtitle)
    @objectPreview.find('.url').text(data.url)

    @objectWrapper.removeClass 'hide'
    @linkAttribute.removeClass 'hide'

    # Update validation
    @titleField.removeClass 'required'
    @urlField.removeClass 'required'
    @objectIdField.addClass 'required'

  expandChildren: ->
    @_getChildren().removeClass 'hide'
    @setIcon()

  setIcon: ->
    icon = 'link'
    classes = ''

    if @_hasChildren()
      icon = if @_getChildren().hasClass('hide') then 'chevron-down' else 'chevron-up'
      classes = 'action'
    else
      icon = 'globe' if @targetField.is(':checked')
      icon = 'list' if @basic()
      icon = @objectIcon() if @object()

    identifier = @container.find('.identifier')
    identifier.removeClass()
    identifier.addClass('fa')
    identifier.addClass('identifier')
    identifier.addClass(classes)
    identifier.addClass("fa-#{icon}")

  _hasChildren: ->
    return true if @outerContainer.has('.children .list-item').length
    false

  openModal: ->
    @modal.foundation('open')

  # Toggle children element visibility
  _toggleChildren: ->
    @_getChildren().toggleClass 'hide'
    @setIcon()

  # Get element which contains children
  _getChildren: ->
    @outerContainer.find('.children')

  _updateListItem: ->
    title = ''
    url = ''
    if @object()
      title = @objectData.title
      url = @objectData.url
    title = @titleField.val() if @titleField.val() != ''
    url = @urlField.val() if @urlField.val() != ''

    @titleText.text(title)
    @urlText.text(url)
    @setIcon()

  basic: ->
    if @typeField.val() == 'Integral::Basic'
      return true
    false

  _getObjectData: ->
    selectedObject = @objectIdField.find(':selected')
    selectedObject.data()

  object: ->
    if @typeField.val() == 'Integral::Object'
      return true
    false

  objectIcon: ->
    icon = @fakeTypeField.find(':selected').data('icon')
    return icon if icon
    'link'

  # Handles when user clicks the ok button on modal
  _handleConfirmClick: ->
    # Validate form before closing Modal
    formValidator = $('#list_form').parsley
      successClass: ''
      errorClass: 'has-error'
      errorsWrapper: '<div class=\"parsley-error-block\"></div>'
      errorTemplate: '<span></span>'
      excluded: 'input:not(.reveal[aria-hidden=false] input)'
      classHandler: (element) =>
        element.$element.closest('.input-field')

    if formValidator.validate()
      @modal.foundation('close')
      sortable('.sortable', 'enable')

      @_updateListItem()
    else
      toastr['error'](I18n.t('errors.fix_errors'))

  # Modal Initialization options
  _modalOptions: ->
    ready: =>
      sortable('.sortable', 'disable')
    complete: =>
      @container.trigger 'modal-close'


  _createSelector: (data) ->
    selector = new window.ResourceSelector(data.resourceSelectorTitle, data.resourceSelectorUrl, { allowFileUpload: false })

    selector.on 'resources-selected', (event) =>
      @handleObjectSelection(event.resources[0])

    selector

  _createAndOpenImageSelector: ->
    if @imageSelector
      @imageSelector.open()
    else
      @imageSelector = new window.ResourceSelector('Select image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"))

      @imageSelector.on 'resources-selected', (event) =>
        @handleImageSelection(event.resources[0])

      setTimeout =>
        @imageSelector.open()
      , 200

  _createAndOpenSelector: ->
    currentSelection = @fakeTypeField.find(":selected").data()

    unless @resourceSelectors[currentSelection.objectType]
      @resourceSelectors[currentSelection.objectType] = @_createSelector(currentSelection)

    setTimeout =>
      @resourceSelectors[currentSelection.objectType].open()
    , 200

