class this.ImageUploader
  @init: ->
    # Could add an initialise check here similar to RecordSelector so that manual initialising an instance is possible
    for instance in $('#new_image_modal')
      new ImageUploader($(instance))

  # NewImageModal constructor
  constructor: (instance, opts={}) ->
    @container = instance
    @submitBtn = $('#new_image_submit_btn')

    @form = $('#new_image')
    @formOpts =
      beforeSubmit:   opts['callbackSubmission'] ? @_handleFormSubmission
      success:        opts['callbackSuccess'] ? @_handleFormSuccess
      error:          opts['callbackFailure'] ? @_handleFormError
      clearForm:      true
      resetForm:      true

    @csvActive = false
    @_setupEvents()

  # Sets event listeners on all gallery image thumbnails
  _setupEvents: ->
    # Initialize form
    @form.ajaxForm(@formOpts)

    # Enable validations. Ideally this would listen to when the modal is opened but this is not possible with Materialize
    # TODO: Update this after updating to Foundation
    observer = new MutationObserver((mutations) =>
      mutations.forEach (mutationRecord) =>
        if @container.css('display') == 'block' && @csvActive == false
          @form.enableClientSideValidations()
          @csvActive = true
    )
    observer.observe(@container[0], { attributes : true, attributeFilter : ['style'] })

  resetForm: ->
    @submitBtn.prop('disabled', false)
    @submitBtn.removeClass('disabled')
    @submitBtn.text('Create image')

  _handleFormSubmission: =>
    @submitBtn.prop('disabled', true)
    @submitBtn.addClass('disabled')
    @submitBtn.text('Uploading..')

  _handleFormSuccess: (createdRecord, statusText, xhr, $form) =>
    @container.foundation('close')
    @_handleModalClosure()
    toastr['success']('Image created.')
    @container.trigger 'record-created', createdRecord

  _handleFormError: =>
    @resetForm()
    toastr['error']('An error occured when uploading the image')

  _handleModalClosure: =>
    @resetForm()
