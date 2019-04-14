# Represents Date Picker - requires jQuery UI Datepicker - https://jqueryui.com/datepicker/
class this.DatePicker
  @getCurrentDate: (element, dateFormat='yy-mm-dd') ->
    date = null
    try
      date = $.datepicker.parseDate( dateFormat, element.value )
    catch error
    date

  @initDateRanges: ->
    $('[data-date-picker-end-element]').each (index, dpStartElement) ->
      $dpStartElement = $(dpStartElement)
      endSelector = "[id='" + $dpStartElement.data().datePickerEndElement + "']"
      $dpEndElement = $(endSelector)

      # Passing these options is doesn't seem to be working?
      dpStart = $dpStartElement.datepicker(
        firstDay: 1
        showAnim: ""
      )
      dpEnd = $dpEndElement.datepicker(
        firstDay: 1
        showAnim: ""
      )
      dpStart.datepicker("option", "firstDay", 1)
      dpEnd.datepicker("option", "firstDay", 1)
      dpStart.datepicker("option", "showAnim", '')
      dpEnd.datepicker("option", "showAnim", '')
      dpStart.on "change", (ev) =>
        dateMinimum = DatePicker.getCurrentDate(ev.currentTarget)
        dateMinimum.setDate(dateMinimum.getDate() + 1)
        dpEnd.datepicker("option", "minDate", dateMinimum)
      dpEnd.on "change", (ev) =>
        dateMaximum = DatePicker.getCurrentDate(ev.currentTarget)
        dateMaximum.setDate(dateMaximum.getDate() - 1)
        dpStart.datepicker("option", "maxDate", dateMaximum)

  constructor: (selector, opts={}) ->
    @selector = selector
    @opts = opts

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
