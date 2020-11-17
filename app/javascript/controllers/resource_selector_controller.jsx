import { Controller } from "stimulus"

// const Uppy = require('@uppy/core')
// const Dashboard = require('@uppy/dashboard')
// const directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
// const ActiveStorageUpload = require('@excid3/uppy-activestorage-upload')

/**
 * Handles resource selection within Integral backend;
 * - Allows users to select a resource from a paginated list of resources.
 * - Pulls in the resources from a list endpoint.
 * - Grid format display, providing a search input field and a resource preview sidebar
 * - TODO: Allow multi-selection
 */
export default class extends Controller {
  static targets = [ "uploadButton", "submitButton", "loadIndicator", "collectionContainer", "searchField", "sidebarDescription", "sidebarTitle", "sidebarImage" ]

  connect() {
    console.log('Connected to resource selector')
    this.selectedItems = []
  }

  // handleInput(event) {
  //   debugger
  //   this.search()
  // }

  // TODO: Add a delay to allow user to finish typing before sending request - otherwise multiple requests made when only one was necessary
  search() {
    let url = this.element.dataset.resourceSelectorUrl + '?' + new URLSearchParams({
      page: 1,
      search: this.searchFieldTarget.value
    })

    fetch(url, {
      method: 'GET'
    })
      .then((response) => response.json())
      .then((data) => {
        this.collectionContainerTarget.innerHTML = data.content
        this.loadIndicatorTarget.classList.add('hide')
        this.collectionContainerTarget.classList.remove('hide')
      }).catch((error) => {
        console.warn(error);

        NotificationManager.notify('Sorry, an error has occurred. Please contact your webmaster.', 'error')
        window.jQuery(this.element).foundation('close')
      })
  }

  select() {
    this.element.dispatchEvent(new CustomEvent('resources-selected', { detail: { resources: this.selectedResources } }))
    window.jQuery(this.element).foundation('close')
  }

  preselect(event) {
    // Clear previous selections
    this.selectedResources = []
    this.collectionContainerTarget.querySelectorAll('.selected').forEach(element => element.classList.remove('selected'))

    let selectedResource = event.currentTarget
    selectedResource.classList.add('selected')
    this.submitButtonTarget.disabled = false
    this.selectedResources = [selectedResource.dataset]

    // Update sidebar
    this.sidebarTitleTarget.innerHTML = selectedResource.dataset.title
    this.sidebarDescriptionTarget.innerHTML = selectedResource.dataset.description
    this.sidebarImageTarget.setAttribute('src', selectedResource.dataset.image)
  }
}
