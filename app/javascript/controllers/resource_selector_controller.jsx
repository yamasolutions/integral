import { Controller } from "stimulus"

const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')
import IntegralStorageFileUpload from 'utils/integral/file_upload';

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

    if (this.hasUploadButtonTarget) {
      this.uppy = this.setupUppy()
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
  search(page=1) {
    let url = this.element.dataset.resourceSelectorUrl + '?' + new URLSearchParams({
      page: page,
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
        this.collectionContainerTarget.querySelectorAll('.pagination a').forEach(element => element.addEventListener('click', (event) => {
          this.changePage(event)
        }))
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

  setupUppy() {
    let directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
    let integralFileUploadUrl = document.querySelector("meta[name='integral-file-upload-url']").getAttribute("content")
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
      showProgressDetails: true,
      proudlyDisplayPoweredByUppy: false,
      closeAfterFinish: true,
      metaFields: [
        { id: 'name', name: 'Name', placeholder: 'File name' },
        { id: 'description', name: 'Description', placeholder: 'Describe what the file is about' }
      ],
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
