class this.NotificationManager
  # Create flashes for all those found within markup
  @flash: ->
    flashList = $('#flash_list .flash')

    for flash in flashList
      flash = $(flash)
      message = flash.data 'message'
      klass = flash.data 'klass'
      # console.log "FLASH! Type: #{klass}. Message: #{message}"
      klass = if klass == 'notice' then 'info' else 'error'

      toastr[klass](message)

  # Pop up a notification
  @notify: (message, type='info') ->
    toastr[type](message)
