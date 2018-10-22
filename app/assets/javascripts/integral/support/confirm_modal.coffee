# Present confirmation dialog to user
$.rails.showConfirmationDialog = (link) ->
  message = link.data("confirm")
  modal = $($.rails.appendConfirmationDialog(link, message))
  new Foundation.Reveal(modal)
  modal.foundation('open')

# Build confirmation Dialog
$.rails.buildConfirmationDialog = (message, modalId, confirmBtnId, cancelBtnId) ->
  "<div class='reveal dialog small' id='#{modalId}' data-reveal>
    <div class='modal-header'>
     <h4>Confirmation</h4>
    </div>
    <div class='modal-content'>
     <p>#{message}</p>
    </div>

    <div class='modal-footer'>
       <a id='#{cancelBtnId}' class='button secondary hollow'>#{I18n.t('integral.backend.confirmation_modal.cancel')}</a>
       <a id='#{confirmBtnId}' class='button primary'>#{I18n.t('integral.backend.confirmation_modal.confirm')}</a>
    </div>
     <button class='close-button' data-close aria-label='Close modal' type='button'>
       <span aria-hidden='true'>&times;</span>
     </button>
   </div>"

# Add confirmation dialog to DOM and setup event listeners
$.rails.appendConfirmationDialog = (link, message) ->
  id = Date.now()
  modalId = "rails_confirm_modal_#{id}"
  confirmBtnId = "rails_confirm_modal_#{id}_confirm_btn"
  cancelBtnId = "rails_confirm_modal_#{id}_cancel_btn"
  modalSelector = "##{modalId}"

  confirmationDialogContents = $.rails.buildConfirmationDialog(message, modalId, confirmBtnId, cancelBtnId)
  $(confirmationDialogContents).appendTo 'body'

  $("##{confirmBtnId}").click ->
    $.rails.confirmed(link)
    $(modalSelector).foundation('close')

  $("##{cancelBtnId}").click =>
    $(modalSelector).foundation('close')

  modalSelector

# Handle user confirmation of confirm modal
$.rails.confirmed = (link) ->
  link.data('confirm', '')
  link.trigger("click.rails")

# Override the default confirm dialog by rails
$.rails.allowAction = (link) ->
  return true if link.data('confirm') == '' || link.data('confirm') == undefined

  $.rails.showConfirmationDialog(link)
  false

