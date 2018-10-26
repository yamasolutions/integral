# Handles interaction with galleries
class this.Gallery
  @init: ->
    new Gallery()

  # Initiate a Gallery
  #
  # @usage new Gallery($('form'))
  constructor: (opts={}) ->
    @placeholder = $('#gallery-placeholder')
    @_setupEvents()


  # Create listeners and handlers for form events
  _setupEvents: =>
    # Watch for when a user opens a gallery
    $('.js-gallery-link').on "click", (event) =>
      @_open_or_create_gallery(event)

  # Open Gallery or create it and open placeholder
  _open_or_create_gallery: (event) =>
    galleryId = event.currentTarget.dataset.target
    return @_handleError() if galleryId == undefined

    gallery = $("##{galleryId}")
    if gallery.length > 0
      gallery.foundation('open')
    else
      url = event.currentTarget.dataset.url
      return @_handleError() if url == undefined
      @_createGallery(galleryId, url)

  # What happens after AJAX request is complete
  _createGallery: (id, url) =>
    # Copy placeholder gallery, set ID, initialize & open
    gallery = @placeholder.clone().appendTo('body')
    gallery.attr('id', id)
    gallery.foundation()
    gallery.foundation('open')

    # Download gallery content
    $.ajax
      url: url,
      context: gallery
    .success (data, textStatus, jqXHR) =>
      @_setupGallery(gallery, data)
    .error (e, data, status, xhr) =>
      @_handleError()

  _setupGallery: (gallery, data) =>
    # Copy gallery into Modal
    gallery.find('.content').html(data)
    galleryContent = gallery.find('.content')

    mainSwiper = galleryContent.find('.main-swiper')
    # Setup galleries
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
    revealHeight = gallery.height()
    thumbSwiperHeight = galleryContent.find('.thumb-swiper').height()
    revealAvailableHeight = revealHeight - thumbSwiperHeight
    mainSwiper.height(revealAvailableHeight)

    window.addEventListener 'resize', =>
      # TODO: Tidy up this duplication
      revealHeight = gallery.height()
      thumbSwiperHeight = galleryContent.find('.thumb-swiper').height()
      revealAvailableHeight = revealHeight - thumbSwiperHeight
      mainSwiper.height(revealAvailableHeight)

    # Listen for arrow keys
    $(document).keydown (event) =>
      return unless gallery.is(':focus')

      switch event.which
        when 37 # Left
          projectGalleryThumbs.slidePrev()
        when 39 # Right
          projectGalleryThumbs.slideNext()
        else
          return # Exit this handler for other keys

    # Show/hide content and placeholder
    gallery.find('.placeholder').css('display', 'none')
    galleryContent.css('visibility', 'initial')

  _handleError: =>
    toastr['error']('Sorry, an unexpected error occurred. Please try again later.')


