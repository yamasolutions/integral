# Represents Date Picker (PickADate)
class this.DatePicker
  @initDateRanges: ->
    $('[data-date-picker-end-element]').each (index, dpStartElement) ->
      $dpStartElement = $(dpStartElement)
      dpStart = $dpStartElement.pickadate('picker')
      $dpEndElement = $('#' + $dpStartElement.data().datePickerEndElement)
      dpEnd = $dpEndElement.pickadate('picker')

      # Check if there’s a “from” or “to” date to start with.
      if dpStart.get('value')
        minimumDate = new Date(dpStart.get('select').obj.valueOf() + 86400000)
        dpEnd.set('min', minimumDate)
      if dpEnd.get('value')
        maximumDate = new Date(dpEnd.get('select').obj.valueOf() - 86400000)
        dpStart.set('max', maximumDate)

      # When something is selected, update the “from” and “to” limits.
      dpStart.on 'set', (event) =>
        if event.select
          minimumDate = new Date(dpStart.get('select').obj.valueOf() + 86400000)
          dpEnd.set('min', minimumDate)

      dpEnd.on 'set', (event) =>
        if event.select
          maximumDate = new Date(dpEnd.get('select').obj.valueOf() - 86400000)
          dpStart.set('max', maximumDate)
        else if 'clear' of event
          dpStart.set('max', false)

  constructor: (selector, opts={}) ->
    @selector = selector
    @opts = opts

    @_setLanguage()
    @_initializeDatePicker()

  _initializeDatePicker: ->
    $(@selector).each (i, dp) =>
      dp = $(dp)

      minRaw = dp[0].min
      maxRaw = dp[0].max
      minDate = new Date minRaw if minRaw
      maxDate = new Date maxRaw if maxRaw
      disabledDates = dp.data('disabled-dates')


      dp.datepicker
        dateFormat: "yy-mm-dd"
        minDate: minDate
        maxDate: maxDate
        beforeShow: @opts.onOpen
        onClose: @opts.onClose
        # Return false to disable a specific date
        beforeShowDay: (currentDate) =>
          return [true] if not disabledDates

          for dateStr in disabledDates.split(',')
            parsedDate = new Date(dateStr)

            return [false] if (parsedDate.getFullYear() == currentDate.getFullYear() and parsedDate.getDate() == currentDate.getDate() and parsedDate.getMonth() == currentDate.getMonth())

          [true]

  getContainer: (dp) ->
    dp.data('date-picker-container')

  getDisabledDates: (dp) ->
    data = dp.data('disabled-dates')
    return [] if not data

    dates = []
    for date in data.split(',')
      dates.push new Date(date)

    dates

  # TODO: Change this to I18n
  _setLanguage: ->
    $.extend($.fn.pickadate.defaults, {
      monthsFull: [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ],
      monthsShort: [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ],
      weekdaysFull: [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ],
      weekdaysShort: [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ],
      weekdaysLetter: [ 'S', 'M', 'T', 'W', 'T', 'F', 'S' ],
      today: 'Today',
      clear: 'Clear',
      close: 'Close',
      firstDay: 1,
    })

