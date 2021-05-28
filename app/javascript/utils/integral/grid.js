class Grid {
  constructor(container) {
    this.container = container;

    this.innerContainer = this.container.querySelector('[data-grid-container]')
    this.form = document.getElementById(this.container.dataset.form)
    this.orderField = this.form.querySelector('.order-field')
    this.descField = this.form.querySelector('.desc-field')
    this.pageField = this.form.querySelector('.page-field')

    this._setupEvents()
  }

  _setupEvents() {
    this.form.addEventListener("change",  (event) => {
      if (event.target.matches('[data-filter]')) {
        this._updatePagination('')
      }
    })

    this.container.addEventListener("click",  (event) => {
      if (event.target.matches('button[data-sort]')) {
        this._updateSort(event.target.dataset.sort, event.target.dataset.desc)
      }
    })

    this.container.addEventListener("click",  (event) => {
      if (event.target.matches('.pagination button')) {
        this._updatePagination(event.target.dataset.page)
      }
    })

    this.form.addEventListener("submit",  (event) => {
      event.preventDefault()

      this.container.classList.add('loading')

      let path = this.form.action + "?"
      for(var pair of new FormData(this.form).entries()){
        path += pair[0] + "=" + pair[1] + "&"
      }
      fetch(path, {
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      })
        .then(response => response.json())
        .then(json => {
          this.container.classList.remove('loading')
          this.container.innerHTML = json.content
        })
        .catch(error => {
          new Toast({ type: 'error', title: 'Unexpected Error', content: 'An error occurred. Please try again later.'})
        })
    })
  }

  _updatePagination(value, redrawGrid=true) {
    this.pageField.value = value

    if (redrawGrid) {
      this._redrawGrid()
    }
  }

  _redrawGrid() {
    this.form.requestSubmit()
  }

  _updateSort(order, desc) {
    this.orderField.value = order
    this.descField.value = desc

    this._redrawGrid()
  }

  _toggleFilterValue(filterName, value) {
    filter = form.querySelector("input[name='#{filterName}']")
    filterArray = filter.val().split(",")
    idx = filterArray.indexOf(value)

    if (idx != -1) {
      filterArray.splice(idx, 1)
    } else {
      filterArray.push(value)
    }

    filter.value = filterArray.join()
    this._redrawGrid()
  }
}
export default Grid;
