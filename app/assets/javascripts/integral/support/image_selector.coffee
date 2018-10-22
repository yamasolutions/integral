# Handles interaction when user selects a single image for a record such as page or post
class this.ImageSelector
  constructor: ->
    if $('[data-image-selector]').length > 0
      @selector = new RecordSelector('[data-image-selector]')
      @_setupEvents()

  _setupEvents: ->
    # Handle Unlink
    $(document).on "click", ".image-select .image-container .remove", (ev) =>
      ev.preventDefault()
      @_unlink(@_getContainer(ev))

    # Handle opening selector
    $(document).on "click", ".image-select .image-container .add, .image-select .image-container .edit", (ev) =>
      ev.preventDefault()
      @_openSelector(@_getContainer(ev))

  # Removes an image association from a record
  _unlink: (container) ->
    container.find('input').val('')
    container.find('.placeholder').removeClass('hide')
    container.find('.actual').addClass('hide')
    container.find('.menu-unlinked').removeClass('hide')
    container.find('.menu-linked').addClass('hide')

  # Open Image Selector
  _openSelector: (container) ->
    @activeContainer = container
    @selector.open(callbackSuccess: @_link)

  # Retrieve image container which holds actual image and hidden association input
  _getContainer: (ev) ->
    $(ev.currentTarget).closest('.image-container')

  _link: (selectedData) =>
    @activeContainer.find('input').val(selectedData.id)
    @activeContainer.find('.placeholder').addClass('hide')
    @activeContainer.find('.actual').attr('src',selectedData.image)
    @activeContainer.find('.actual').removeClass('hide')
    @activeContainer.find('.menu-unlinked').addClass('hide')
    @activeContainer.find('.menu-linked').removeClass('hide')

