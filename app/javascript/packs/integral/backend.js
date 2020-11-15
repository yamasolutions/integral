import "controllers";


const Uppy = require('@uppy/core')
const Dashboard = require('@uppy/dashboard')
const ActiveStorageUpload = require('@excid3/uppy-activestorage-upload')

require('@uppy/core/dist/style.css')
require('@uppy/dashboard/dist/style.css')

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-uppy]').forEach(element => setupUppy(element))
})

function setupUppy(element) {
  let target = element.querySelector('[data-behavior="uppy-target"]')
  let form = element.querySelector('form')
  let direct_upload_url = document.querySelector("meta[name='direct-upload-url']").getAttribute("content")

  let uppy = Uppy({
    // autoProceed: true,
    // allowMultipleUploads: true,
    logger: Uppy.debugLogger
  })

  uppy.use(ActiveStorageUpload, {
    directUploadUrl: direct_upload_url
  })

  uppy.use(Dashboard, {
    target: target,
    inline: true,
    width: '100%',
    proudlyDisplayPoweredByUppy: false,
    metaFields: [
      { id: 'name', name: 'Name', placeholder: 'File name' },
      { id: 'description', name: 'Description', placeholder: 'Describe what the file is about' }
    ],
  })

  uppy.on('complete', (result) => {
    result.successful.forEach(file => {
      // debugger
      // Also need title and description
      createFile(form, 'foo title', 'foo description', file.response.signed_id)
      // Although its successfully uploaded the file hasn't yet been created - need to somehow not display the success stuff yet
    })
  })
}

/*
 * Creates an Integral::Storage::File using the signedId of the uploaded Active Storage blob along
 * with the title and description the user provided
 */
function createFile(form, title, description, signedId) {
  let formData = new FormData(form)
  formData.set('storage_file[title]', title)
  formData.set('storage_file[description]', description)
  formData.set('storage_file[attachment]', signedId)

  fetch(form.action, {
    method: 'POST',
    body: formData,
  }).then(function (response) {
    if (response.ok) {
      console.log(`File created! %{response}`) // How to do string interpol?
      // Here we'd mark the uppy file upload as complete
      // return response.json()
    }
    return Promise.reject(response);
  }).then(function (data) {
    console.log(data);
  }).catch(function (error) {
    console.warn(error);
      // Here we'd mark the uppy file upload as errored out
  });
}
