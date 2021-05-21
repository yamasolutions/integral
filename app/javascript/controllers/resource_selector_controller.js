import { Controller } from "stimulus"

const Uppy = require('@uppy/core')
const directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
const integralFileUploadUrl = document.querySelector("meta[name='integral-file-upload-url']").getAttribute("content")

import Dashboard from 'utils/integral/file-upload/dashboard'
import IntegralStorageFileUpload from 'utils/integral/file-upload/uploader';

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
    this.selectedItems = []

    if (this.hasUploadButtonTarget) {
      this.uppy = this.setupUppy()
    }

    if (this.element.dataset.resourceSelectorDefaultFilters) {
      this.defaultFilters = JSON.parse(this.element.dataset.resourceSelectorDefaultFilters)
    } else {
      this.defaultFilters = {}
    }
  }

  changePage(event) {
    event.preventDefault()

    let params = new URLSearchParams(event.currentTarget.href.split('?')[1])
    this.search(params.get('page'))
  }

  open(event) {
    this.search()
  }

  upload() {
    this.uppy.getPlugin('Dashboard').openModal()
  }

  // TODO: Add a delay to allow user to finish typing before sending request - otherwise multiple requests made when only one was necessary
  searchInput() {
    this.search()
  }

  search(page=1) {
    let searchFilters = Object.assign({}, this.defaultFilters, { page: page, search: this.searchFieldTarget.value })
    let url = this.element.dataset.resourceSelectorUrl + '?' + new URLSearchParams(searchFilters)

    fetch(url, {
      method: 'GET'
    })
      .then((response) => response.json())
      .then((data) => {
        this.collectionContainerTarget.innerHTML = data.content
        this.loadIndicatorTarget.classList.add('d-none')
        this.collectionContainerTarget.classList.remove('d-none')
        this.collectionContainerTarget.querySelectorAll('.pagination a').forEach(element => element.addEventListener('click', (event) => {
          this.changePage(event)
        }))
      }).catch((error) => {
        new Toast({ type: "error", title: "Error", content: 'Sorry, an error has occurred. Please contact your webmaster.' })
        bootstrap.Modal.getInstance(this.element).hide()
      })
  }

  select() {
    this.element.dispatchEvent(new CustomEvent('resources-selected', { detail: { resources: this.selectedResources } }))
    bootstrap.Modal.getInstance(this.element).hide()
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

  setupUppy() {
    let fileRestrictions = JSON.parse(this.uploadButtonTarget.dataset.fileRestrictions)

    let uppy = Uppy({
      allowMultipleUploads: false,
      restrictions: fileRestrictions
    })

    uppy.use(IntegralStorageFileUpload, {
      directUploadUrl: directUploadUrl,
      integralFileUploadUrl: integralFileUploadUrl,
      authenticityToken: this.element.dataset.token
    })

    uppy.use(Dashboard, {
      closeAfterFinish: true
    })

    uppy.on('complete', (result) => {
      this.processUploads(result)
    })

    return uppy
  }

  processUploads(result) {
    result.successful.forEach(file => {
      let data = file.response.data
      let resourceElement = this.collectionContainerTarget.querySelector('.placeholder .cell').cloneNode(true)

      for (const [key, value] of Object.entries(data)) {
        resourceElement.querySelector('.record').setAttribute(`data-${key}`, value);
      }
      resourceElement.querySelector('img').setAttribute('src', data.image)
      // resourceElement.querySelector('.title').innerHTML = data.title
      // resourceElement.querySelector('.subtitle').innerHTML = data.subtitle

      this.collectionContainerTarget.querySelector('.grid-x').prepend(resourceElement)
      setTimeout(() => {
        resourceElement.querySelector('.record').click()
      }, 200); // Not sure why but timeout was required here otherwise click was not registered
    })

    if (this.collectionContainerTarget.querySelector('.no-records') != null) {
      this.collectionContainerTarget.querySelector('.no-records').classList.remove('hide')
    }
    this.uppy.reset()
  }
}
