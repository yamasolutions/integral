# Used to select different objects
# In future should be able to handle multi-selection
class this.RecordSelector
  @instances = []

  @init: ->
    @instances = []
    for selector in $('[data-record-selector-initialize]')
      $selector = $(selector)
      name = $selector.data('record-selector-name')
      return unless name

      selectorId = @generateUniqueId()
      $selector.attr('id', selectorId)
      @instances.push new RecordSelector("##{selectorId}", name)

  # Open Record Selector with given name - If no such RecordSelector exists do nothing
  @open: (selectorName, opts={}) ->
    for selector in @instances
      if selector.name.toLowerCase() == selectorName.toLowerCase()
        selector.open(opts)
        return

    console.log "RecordSelector: No such selector exists - #{selectorName}"

  @generateUniqueId: ->
    charstoformid = '_0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('')
    uniqid = ''
    idlength = Math.floor(Math.random() * charstoformid.length)

    for num in [0..idlength]
      uniqid += charstoformid[Math.floor(Math.random() * charstoformid.length)]

    # One last step is to check if this ID is already taken by an element before
    if $("#"+uniqid).length == 0
      return uniqid
    else
      return uniqID(20)

  constructor: (containerSelector, name) ->
    @name = name
    @containerSelector = containerSelector
    @container = $(containerSelector)
    @progressBar = @container.find('.loader')
    @selectButton = @container.find('.select.button')
    @closeButton = @container.find('.close-btn')
    @searchPath = @container.data('record-path')
    @searchField = @container.find('.search-field')
    @pageField = @container.find('.page-field')
    @recordsContainer = @container.find('.records')
    @placeholder = @recordsContainer.find('.placeholder .cell')
    @selectedText = @container.find('.selected')
    @createButton = @container.find('button.create-button')
    @previousSearch = ''
    @form = @container.find('form')
    @_setupEvents()

  open: (opts={}) ->
    @_callbackSuccess = opts['callbackSuccess'] ? undefined
    @_callbackFailure = opts['callbackFailure'] ? undefined
    @selectedId = opts['preselectedId'] ? -1
    @container.foundation('open')
    @form.submit()

  _setupEvents: ->
    if @createButton.length > 0
      createWidget = $ @createButton.data('target')

      # Handle click on create button
      @createButton.on 'click', (e) =>
        e.preventDefault()
        createWidget.foundation('open')

      # Handle created record
      createWidget.on 'record-created', (e, record) =>
        # Copy placeholder, set attributes & fire click event
        new_item = @placeholder.clone().prependTo(@recordsContainer.find('.grid-x'))
        new_item.find('.record').data(record)
        new_item.find('.record').data('image', record.image.url)
        new_item.find('img').attr('src', record.image.url)
        new_item.find('.subtitle').text(record.subtitle)
        new_item.find('.title').text(record.title)
        new_item.find('.record').trigger('click')

    # handle click on record
    @recordsContainer.on 'click', '.record', (e) =>
      $(@containerSelector).find(".record.selected").removeClass 'selected'
      @selectedRecord = $(e.target).closest('.record')
      @selectedData = @selectedRecord.data()
      @selectedId = @selectedData.id
      @selectedRecord.addClass 'selected'
      @selectButton.removeClass 'disabled'
      @_updateDetails()

    @searchField.keypress (ev) =>
      @pageField.val(1)
      @form.submit() if @searchField.val() != @previousSearch && ev.which == 13

    @recordsContainer.on 'click', '.pagination a', (ev) =>
      ev.preventDefault()
      pageNumber = @getUrlVars(ev.target.href)['page']
      @pageField.val(pageNumber)
      @form.submit()

    @form.on "ajax:beforeSend", (e, data, status, xhr) =>
      @_handleSearchSubmission()
    @form.on "ajax:success", (e, data, status, xhr) =>
      @_handleSuccessfulSearch(data)
    @form.on "ajax:error", (e, xhr, status, error) =>
      @_handleFailedSearch(error)

    @closeButton.click (ev) =>
      @_handleQuit()

    @selectButton.click (ev) =>
      ev.preventDefault()
      if @selectedRecord
        @container.foundation('close')
        @container.trigger 'object-selection', [@selectedData]
        @_callbackSuccess(@selectedData) if @_callbackSuccess

  # Update details sidebar panel
  _updateDetails: ->
    @container.find('.sidebar img').attr('src', @selectedData.image || '')
    @container.find('.sidebar .title').text(@selectedData.title)
    @container.find('.sidebar .description').text(@selectedData.description)

  _handleQuit: ->
    @_callbackFailure() if @_callbackFailure

  _handleSuccessfulSearch: (data) ->
    @recordsContainer.html(data['content'])
    @progressBar.hide()
    @recordsContainer.show()

    $(@containerSelector).find(".record[data-id='" + @selectedId + "']").addClass 'selected' if @selectedId

  _handleFailedSearch: (data) ->
    @container.foundation('close')
    NotificationManager.notify('Sorry, an error has occurred. Please contact your webmaster.', 'error')
    @_callbackFailure() if @_callbackFailure

  _handleSearchSubmission: ->
    @progressBar.show()
    @recordsContainer.hide()
    @previousSearch = @searchField.val()

  # Move out into main file to extend jquery
  getUrlVars: (url) ->
    vars = []
    hashes = url.slice(url.indexOf('?') + 1).split('&')

    for hash in hashes
      hashArr = hash.split('=')
      vars.push(hashArr[0])
      vars[hashArr[0]] = hashArr[1]
    vars

  getUrlVar: (url, name) ->
    @getUrlVars(url)[name]

