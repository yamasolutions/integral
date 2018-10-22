# Handles displaying, sorting and filtering of data
class this.Grid
  @init: ->
    for grid in $('[data-grid]')
      new Grid($(grid))

  # Grid constructor
  constructor: (container) ->
    @container = container
    @innerContainer = @container.find('[data-grid-container]')
    @gridCount = @container.find('[data-grid-count]')
    @form = $("##{container.data('form')}")
    @orderField = @form.find('.order-field')
    @descField = @form.find('.desc-field')
    @pageField = @form.find('.page-field')

    @_setupEvents()

  _setupEvents: ->
    @form.on 'change', '[data-filter]', (ev) =>
      @_updatePagination('', false)

    @container.on 'change', '[data-filter]', (ev) =>
      @_updatePagination('', false)

    @container.on 'change', 'input[type=checkbox][data-filter]', (ev) =>
      @_toggleFilterValue(ev.target.dataset.filter, ev.target.dataset.value)

    @form.on 'change', 'select[data-filter]', (ev) =>
      @_redrawGrid()

    @container.on 'click', 'button[data-sort]', (ev) =>
      @_updateSort(ev.target.dataset.sort, ev.target.dataset.desc)

    @container.on 'change', 'select[data-sort]', (ev) =>
      selectedOption = $(ev.target).find(':selected')
      @_updateSort(selectedOption.data('sort'), selectedOption.data('desc'))

    @container.on 'click', '.pagination button', (ev) =>
      @_updatePagination(ev.target.dataset.page)

    # Form submission
    @form.on "ajax:beforeSend", (event, data, status, xhr) =>
      @container.addClass('loading')
      @container.find('[data-grid-container]').addClass('loading')

    # Form successfully submitted
    @form.on "ajax:success", (event, data, status, xhr) =>
      if @innerContainer.length != 0
        @innerContainer.html(data.content)
      else
        @container.html(data.content)

      @gridCount.text(data.count)
      @container.removeClass('loading')
      @container.find('[data-grid-container]').removeClass('loading')

    # @form.on "ajax:complete", (event, data, status, xhr) =>
    #   console.log 'Complete!'
    # @form.on "ajax:error", (event, data, status, xhr) =>
    #   console.log 'Error!'

  _updateSort: (order, desc)->
    @orderField.val(order)
    @descField.val(desc)

    @_redrawGrid()

  _updatePagination: (page, redraw = true)->
    @pageField.val(page)

    if redraw
      @_redrawGrid()
      @container.trigger('paginated')

  # Handles toggling filter values within multiple selections
  _toggleFilterValue: (filterName, value)->
    filter = @form.find("input[name='#{filterName}']")
    filterArray = filter.val().split(",")
    idx = filterArray.indexOf(value)

    if idx != -1
      filterArray.splice(idx, 1)
    else
      filterArray.push(value)

    filter.val(filterArray.join())
    @_redrawGrid()

  _redrawGrid: ->
    @form.submit()

