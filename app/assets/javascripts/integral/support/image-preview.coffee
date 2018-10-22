document.addEventListener "turbolinks:load", ->
  imageUploader = $(".image-uploader")

  imageUploader.on 'change', ->
    if (typeof (FileReader) != "undefined")
      imgSelector = $(this).data('preview-selector')
      imageContainer = $(imgSelector)
      reader = new FileReader()
      reader.onload = (e) =>
        imageContainer.attr('src', e.target.result)
      reader.readAsDataURL($(this)[0].files[0])
    else
      console.log("This browser does not support FileReader.")

