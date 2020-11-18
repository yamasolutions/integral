import "controllers";

const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')

require('@uppy/core/dist/style.css')
require('@uppy/dashboard/dist/style.css')

import IntegralStorageFileUpload from 'utils/integral/file_upload';

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-uppy]').forEach(element => setupUppy(element))
})

function setupUppy(element) {
  let target = element.querySelector('[data-behavior="uppy-target"]')
  let directUploadUrl = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")
  let integralFileUploadUrl = document.querySelector("meta[name='integral-file-upload-url']").getAttribute("content")

  let uppy = Uppy()

  uppy.use(IntegralStorageFileUpload, {
    directUploadUrl: directUploadUrl,
    integralFileUploadUrl: integralFileUploadUrl,
    authenticityToken: element.dataset.token
  })

  uppy.use(Dashboard, {
    target: target,
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
