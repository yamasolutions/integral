# Handles interaction with remote forms
class this.RemoteForm
  # Initiate a RemoteForm object with a jquery selector to one or more forms
  #
  # @usage new RemoteForm($('form'))
  constructor: (forms, opts={}) ->
    # 'forms' refers to one or more jquery objects whose target is a 'form' tag
    @forms = forms
    @opts = @_mergeDefaultOpts(opts)
    @_setupEvents()

  # Create listeners and handlers for form events
  _setupEvents: =>
    # Handle form start
    @forms.on "ajax:beforeSend", (xhr, opts) =>
      @opts.handleBeforeSend(xhr, opts)

    # Handle form success
    @forms.on "ajax:success", (event, data, status, xhr) =>
      @opts.handleSuccess(event, data)

    # Handle form error
    @forms.on "ajax:error", (event, data, status, xhr) =>
      @opts.handleError(event, data)

    # Handle form complete
    @forms.on "ajax:complete", (event, data, status, xhr) =>
      @opts.handleComplete(event, data)

  # What happens before AJAX request is sent
  _handleBeforeSend: (event, data) =>
    @_setDisabledElements(event.currentTarget)

  # What happens after AJAX request is complete
  _handleComplete: (event, data) =>
    @_setDisabledElements(event.currentTarget, false)
    $(event.currentTarget).resetClientSideValidations()

  # What happens after AJAX request is complete with an error
  _handleError: (event, data) =>
    formDataError = $(event.currentTarget).data('remote-form-failure-message')
    return @errorMessage(I18n.t('integral.remote_form.error')) if data.status == 500
    return @errorMessage(data.responseJSON.message) if data.responseJSON != undefined && data.responseJSON.message != undefined
    return @errorMessage(formDataError) if formDataError
    @errorMessage(I18n.t('integral.remote_form.error'))

  # What happens after AJAX request is complete successfully
  _handleSuccess: (event, data) =>
    target = $(event.currentTarget)
    formDataSuccessMessage = target.data('remote-form-success-message')
    data = {} if data == undefined

    @broadcastEvent(target)

    # Reset form
    target[0].reset()

    return Turbolinks.visit(data.redirect_url) if data.redirect_url
    return @successMessage(data.message) if data.message
    return @successMessage(formDataSuccessMessage) if formDataSuccessMessage
    @successMessage(I18n.t('integral.remote_form.success'))

  # Loops over all elements within a target and toggles the disabled attribute
  _setDisabledElements: (target, disabled=true) =>
    for element in target
      element.disabled = disabled

  errorMessage: (message) =>
    toastr["error"](message)

  successMessage: (message) =>
    toastr["success"](message)

  # Broadcast a GTM event if one is supplied
  broadcastEvent: (target) =>
    event = target.data('remote-form-event')

    # Broadcast Google Event
    if event != ''
      window.dataLayer = window.dataLayer || []
      window.dataLayer.push
        'event' : event

  _mergeDefaultOpts: (opts) =>
    default_opts =
      handleBeforeSend: @_handleBeforeSend
      handleSuccess: @_handleSuccess
      handleError: @_handleError
      handleComplete: @_handleComplete

    $.extend({}, default_opts, opts)
