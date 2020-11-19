import { Controller } from "stimulus"

const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')

require('@uppy/core/dist/style.css')
require('@uppy/dashboard/dist/style.css')

import IntegralStorageFileUpload from 'utils/integral/file_upload';


export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    let directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
    let integralFileUploadUrl = document.querySelector("meta[name='integral-file-upload-url']").getAttribute("content")
    let acceptedFileTypes = document.querySelector("meta[name='integral-file-accepted-types']").getAttribute("content").split(',')
    let maxFileSize = document.querySelector("meta[name='integral-file-maximum-size']").getAttribute("content")

    let uppy = Uppy({
      restrictions: {
        maxFileSize: parseInt(maxFileSize),
        allowedFileTypes: acceptedFileTypes
      }
    })

    uppy.use(IntegralStorageFileUpload, {
      directUploadUrl: directUploadUrl,
      integralFileUploadUrl: integralFileUploadUrl,
      authenticityToken: this.element.dataset.token
    })

    uppy.use(Dashboard, {
      target: this.containerTarget,
      inline: true,
      width: '100%',
      showProgressDetails: true,
      proudlyDisplayPoweredByUppy: false,
      metaFields: [
        { id: 'name', name: 'Name', placeholder: 'File name' },
        { id: 'description', name: 'Description', placeholder: 'Describe what the file is about' }
      ],
    })
  }
}
