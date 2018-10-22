# Handles chart manipulation
# http://www.chartjs.org/
class this.ChartManager
  @colors = [
    '#1b8ecf',
    '#316498',
    '#2d4a67',
    '#17212b'
  ]

  @randomScalingFactor: ->
    Math.round(Math.random() * 100)

  constructor: ->
    @set_defaults()
    @renderChart(element) for element in $('canvas[data-chart]')

  # Render chart from supplied element
  renderChart: (element) ->
    dataset = @parseData(element)

    config = switch element.dataset.chartType
      when 'donut' then @donutChart(element, dataset)
      when 'line' then @lineChart(element, dataset)
      else @respond_to_invalid_chart_type()

    new Chart(element, config)

  # Render data for donut chart from supplied element
  # http://www.chartjs.org/docs/latest/charts/doughnut.html
  #
  # @return [Hash] config created from parameters to create donut chart
  donutChart: (element, dataset) ->
    {
      type: 'doughnut',
      data: {
        datasets: [{
          data: _.map dataset[0]['data'], (item) ->
            item.value
          backgroundColor: ChartManager.colors
        }],
        labels: _.map dataset[0]['data'], (item) ->
          item.label
      },
      options: {
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) ->
              data.labels[tooltipItem.index]
          }
        },
        responsive: true,
        legend: {
          position: 'right'
        },
        title: {
          display: false
        },
        animation: {
          animateScale: true,
          animateRotate: true
        }
      }
    }

  # Render data for line chart from supplied element
  # http://www.chartjs.org/docs/latest/charts/line.html
  #
  # @return [Hash] config created from parameters to create line chart
  lineChart: (element, rawDataset) ->
    chartData = _.map rawDataset, (item, i) ->
      {
        label: item['label'],
        data: _.map item['data'], (item) ->
          item.value
        backgroundColor: ChartManager.colors[i],
        borderColor: ChartManager.colors[i],
        borderWidth: 1,
        pointRadius: 2,
        fill: false
      }

    {
      type: 'line',
      data: {
        labels: element.dataset.chartLabels.split(',')
        datasets: chartData
      },
      options: {
        scales: {
          xAxes: [{
            gridLines: {
              display: false,
              color: '#d4dfef',
              drawBorder: false
            }
          }],
          yAxes: [{
            ticks: {
              maxTicksLimit: 4
            },
            gridLines: {
              color: '#d4dfef',
              drawBorder: false,
              zeroLineColor: '#d4dfef'
            }
          }]
        },
        responsive: true,
        legend: {
          position: 'bottom'
        },
        title:{
          display: false
        }
      }
    }

  # Response when an invalid chart type is supplied
  respond_to_invalid_chart_type: ->
    console.log 'Invalid chart type supplied.'

  # Set ChartJS defaults
  set_defaults: ->
    Chart.defaults.global.defaultFontColor = '#17212b';
    Chart.defaults.global.defaultFontFamily = "'Nunito', 'Helvetica Neue', Helvetica, Roboto, Arial, sans-serif"

  # Parse chart data from element markup
  parseData: (element) ->
    dataset = []

    $(element).find('ul').each (i, elementSet) =>
      dSet = {}
      dSet['data'] = []
      dSet['label'] = elementSet.dataset.chartLabel

      $(elementSet).find('li').each (i, elementItem) =>
        dItem = $(elementItem)
        dSet['data'].push {
          value: dItem.data('value'),
          label: dItem.text()
        }
      dataset.push dSet
    dataset

