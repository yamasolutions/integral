class this.ClickToCopy
  # Create flashes for all those found within markup
  @init: ->
    $('.copy-url').click (ev) ->
      ev.preventDefault()
      target = $(ev.currentTarget)

      # Create hidden input to copy the URL from
      hiddenInput = document.createElement("textarea")
      hiddenInput.style.position = "absolute"
      hiddenInput.style.left = "-9999px"
      hiddenInput.style.top = "0"
      hiddenInput.id = $.now()
      document.body.appendChild(hiddenInput)

      # Add text into hidden input & copy it
      hiddenInput.textContent = target.attr('href')
      hiddenInput.focus()
      hiddenInput.setSelectionRange(0, hiddenInput.value.length)
      document.execCommand("copy")

      # Notify user URL has been copied
      targetSpan = target.find('span')
      originalText = targetSpan.text()
      targetSpan.text(I18n.t('integral.actions.copied'))
      window.setTimeout ->
        targetSpan.text(originalText)
      , 300
