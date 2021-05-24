class Grid {
  constructor(container) {
    this.container = container;

    this.innerContainer = this.container.querySelector('[data-grid-container]')
    // this.gridCount = this.container.querySelector('[data-grid-count]')
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

    // this.container.addEventListener("change",  (event) => {
    //   if (event.target.matches('[data-filter]')) {
    //     this._updatePagination('', false)
    //   }
    //   if (event.target.matches('input[type=checkbox][data-filter]')) {
    //     this._updatePagination('', false)
    //     this._toggleFilterValue(ev.target.dataset.filter, ev.target.dataset.value)
    //   }
    // })
    //
    // this.container.addEventListener("change",  (event) => {
    //   if (event.target.matches('select[data-filter], input[type=text][data-filter]')) {
    //     filterName = ev.target.dataset.filter
    //     filter = this.form.querySelector("input[name='#{filterName}']")
    //     filter.value = ev.target.value
    //
    //     this._redrawGrid()
    //   }
    // })

    // this.form.addEventListener("change",  (event) => {
    //   if (event.target.matches('select[data-filter], input[type=search][data-filter]')) {
    //     this._redrawGrid()
    //   }
    // })

    this.container.addEventListener("click",  (event) => {
      if (event.target.matches('button[data-sort]')) {
        this._updateSort(event.target.dataset.sort, event.target.dataset.desc)
      }
    })

    // this.container.addEventListener("change",  (event) => {
    //   if (event.target.matches('select[data-sort]')) {
    //     selectedOption = event.target.querySelector(':selected')
    //     this._updateSort(selectedOption.dataset.sort, selectedOption.dataset.desc)
    //   }
    // })

    this.container.addEventListener("click",  (event) => {
      if (event.target.matches('.pagination button')) {
        this._updatePagination(event.target.dataset.page)
      }
    })

    this.form.addEventListener("submit",  (event) => {
      event.preventDefault()

      this.container.classList.add('loading')
      // this.container.querySelector('[data-grid-container]').classList.add('loading')

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
          // this.container.querySelector('[data-grid-container]').classList.remove('loading')

          // if (this.innerContainer.length != 0) {
          //   this.innerContainer.html(json.content)
          // } else {
          //   this.container.html(json.content)
          // }
          this.container.innerHTML = json.content

          // this.gridCount.text = json.count
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
      // this.container.trigger('paginated')
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
