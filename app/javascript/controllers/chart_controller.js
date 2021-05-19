import { Controller } from "stimulus"
import Chart from 'chart.js/auto'

// Chart.defaults.global.defaultFontColor = '#17212b';
// Chart.defaults.global.defaultFontFamily = "'Nunito', 'Helvetica Neue', Helvetica, Roboto, Arial, sans-serif"

export default class extends Controller {
  connect() {
    this.renderChart()
  }

  colors() {
    return [
      '#1b8ecf',
      '#316498',
      '#2d4a67',
      '#17212b'
    ]
  }

  renderChart() {
    switch(this.element.dataset.chartType) {
      case 'donut':
        new Chart(this.element, this.donutConfiguration(this.parseData()))
        break;
      case 'line':
        new Chart(this.element, this.lineConfiguration(this.parseData()))
        break;
      default:
        console.error('Invalid chart type supplied.')
    }
  }

  parseData() {
    let data = []
    this.element.querySelectorAll('ul').forEach(function (list, priority) {
      let listData = {}
      listData['label'] = list.dataset.chartLabel
      listData['data'] = []
      list.querySelectorAll('li').forEach(function (listItem, priority) {
        listData['data'].push ({
          value: listItem.dataset.value,
          label: listItem.innerHTML
        })
      })
      data.push(listData)
    });
    return data;
  }

  donutConfiguration(data) {
    return {
      type: 'doughnut',
      data: {
        datasets: [{
          data: data[0].data.map(o => o.value),
          backgroundColor: this.colors()
        }],
        labels: data[0].data.map(o => o.label)
      },
      options: {
        // tooltips: {
        //   callbacks: {
        //     label: (tooltipItem, data) ->
        //       data.labels[tooltipItem.index]
        //   }
        // },
        responsive: true,
        plugins: {
          legend: {
            position: 'right'
          }
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
  }

  lineConfiguration(data) {
    let chartData = []

    data.forEach((item, i)  => {
      chartData.push({
        label: item['label'],
        data: item.data.map(o => o.value),
        backgroundColor: this.colors()[i],
        borderColor: this.colors()[i],
        borderWidth: 1,
        pointRadius: 2,
        fill: false
      })
    })

    return {
      type: 'line',
      data: {
        labels: this.element.dataset.chartLabels.split(','),
        datasets: chartData
      },
      options: {
        scales: {
          x: {
            grid: {
              display: false,
              color: '#d4dfef',
              drawBorder: false
            }
          },
          y: {
            ticks: {
              maxTicksLimit: 4
            },
            grid: {
              color: '#d4dfef',
              drawBorder: false,
              zeroLineColor: '#d4dfef'
            }
          }
        },
        responsive: true,
        plugins: {
          legend: {
            position: 'bottom'
          }
        },
        title:{
          display: false
        }
      }
    }
  }
}
