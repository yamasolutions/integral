# Handles interaction with galleries
class this.Gallery
  @init: ->
    # Watch for when a user opens a gallery
    $('.js-gallery-link').on "click", (event) =>
      target = event.currentTarget.dataset.target
      url = event.currentTarget.dataset.url
      @open_or_create_gallery(target, url)

    # Install YouTube library
    tag = document.createElement('script')
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

  # Open Gallery or create new one
  @open_or_create_gallery: (id, url) =>
    return Gallery.handleError() if id == undefined

    gallery = $("##{id}")
    if gallery.length > 0
      gallery.foundation('open')
    else
      return Gallery.handleError() if url == undefined
      new Gallery(id, url)

  @handleError: =>
    toastr['error']('Sorry, an unexpected error occurred. Please try again later.')

  # Initiate a Gallery
  #
  # @usage new Gallery('myGallery', 'link-to-gallery-content')
  constructor: (id, url, opts={}) ->
    placeholder = $('#gallery-placeholder')

    # Copy placeholder gallery, set ID, initialize & open
    @$container = placeholder.clone().appendTo('body')
    @youtubeEmbeds = []
    @$container.attr('id', id)
    @$container.foundation()
    @$container.foundation('open')

    # Download gallery content
    $.ajax
      url: url,
    .success (data, textStatus, jqXHR) =>
      @_setupGallery(data)
    .error (e, data, status, xhr) =>
      Gallery.handleError()

  _setupGallery: (data) =>
    # Copy gallery into Modal
    @$container.find('.content').html(data)
    galleryContent = @$container.find('.content')

    @_setupYoutube()

    mainSwiper = galleryContent.find('.main-swiper')
    # Setup galleries (when present)
    if mainSwiper.length > 0
      projectGalleryTop = new Swiper(mainSwiper[0], {
        spaceBetween: 10,
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
        },
      })
      projectGalleryThumbs = new Swiper(galleryContent.find('.thumb-swiper'), {
        spaceBetween: 10,
        centeredSlides: true,
        slidesPerView: 'auto',
        touchRatio: 0.2,
        slideToClickedSlide: true,
      })
      projectGalleryTop.controller.control = projectGalleryThumbs
      projectGalleryThumbs.controller.control = projectGalleryTop

    # Set main swiper size
    revealHeight = @$container.height()
    if mainSwiper.length > 0
      thumbSwiperHeight = galleryContent.find('.thumb-swiper').height()
      revealAvailableHeight = revealHeight - thumbSwiperHeight
      mainSwiper.height(revealAvailableHeight)
    else
      galleryContent.height(revealHeight)

    window.addEventListener 'resize', =>
      # TODO: Tidy up this duplication
      revealHeight = @$container.height()
      if mainSwiper.length > 0
        thumbSwiperHeight = galleryContent.find('.thumb-swiper').height()
        revealAvailableHeight = revealHeight - thumbSwiperHeight
        mainSwiper.height(revealAvailableHeight)
      else
        galleryContent.height(revealHeight)

    # Listen for arrow keys
    $(document).keydown (event) =>
      return unless @$container.is(':focus')

      switch event.which
        when 37 # Left
          projectGalleryThumbs.slidePrev()
        when 39 # Right
          projectGalleryThumbs.slideNext()
        else
          return # Exit this handler for other keys

    # Show/hide content and placeholder
    @$container.find('.placeholder').css('display', 'none')
    galleryContent.css('visibility', 'initial')

  # We could lazy load YT library here and check if any embeds actually exist but then we have to wait for the YT library to download and replace the iframe.
  _setupYoutube: =>
    embeds = @$container.find('iframe')
    if embeds.length > 0
      console.log("Youtube embeds exist #{embeds.length}")
      embeds.each (index, element) =>
        player = new YT.Player element#,
          # videoId: 'mNzvpFcJXU4', // This is provided by the URL in the element
          # playerVars:
          #   'origin': 'http://localhost:3000',
          #   'host': 'https://www.youtube.com'
        @youtubeEmbeds.push player

        @$container.on 'closed.zf.reveal', =>
          @youtubeEmbeds.forEach (element) =>
            element.pauseVideo()
