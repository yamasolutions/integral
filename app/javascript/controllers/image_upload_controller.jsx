import { Controller } from "stimulus"

const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')
const directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
const ActiveStorageUpload = require('@excid3/uppy-activestorage-upload')

export default class extends Controller {
  static targets = [ "updateButton", "createButton", "idField", "previewImage"]

  open() {
    const uppy = new Uppy({
      autoProceed: true,
      allowMultipleUploads: false,
      debug: true,
      restrictions: {
        maxNumberOfFiles: 1,
        allowedFileTypes: ['image/*']
      },
    })

    uppy.use(ActiveStorageUpload, {
      directUploadUrl: directUploadUrl
    })

    uppy.use(Dashboard, {
      showProgressDetails: true,
      proudlyDisplayPoweredByUppy: false,
      closeAfterFinish: true
    })

    uppy.getPlugin('Dashboard').openModal()

    uppy.on('complete', (result) => {
      result.successful.forEach(file => {
        this.idFieldTarget.value = file.response.signed_id
        this.previewImageTarget.setAttribute('src', file.preview)

        this.updateButtonTarget.classList.remove('hide')
        this.createButtonTarget.classList.add('hide')
      })
    })
  }
}
