# Handles interaction with galleries
class this.Gallery
  @init: ->
    # Watch for when a user opens a gallery
    $('.js-gallery-link').on "click", (event) =>
      target = event.currentTarget.dataset.target
      url = event.currentTarget.dataset.url
      @open_or_create_gallery(target, url)

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
    @$galleryContent = @$container.find('.content')

    @_setupYoutube()

    @$mainSwiper = @$galleryContent.find('.main-swiper')
    # Setup galleries (when present)
    if @$mainSwiper.length > 0
      projectGalleryTop = new Swiper(@$mainSwiper[0], {
        spaceBetween: 10,
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
        },
      })
      projectGalleryThumbs = new Swiper(@$galleryContent.find('.thumb-swiper'), {
        spaceBetween: 10,
        centeredSlides: true,
        slidesPerView: 'auto',
        touchRatio: 0.2,
        slideToClickedSlide: true,
      })
      projectGalleryTop.controller.control = projectGalleryThumbs
      projectGalleryThumbs.controller.control = projectGalleryTop

    @_setSwiperSize()

    window.addEventListener 'resize', =>
      @_setSwiperSize()

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
    @$galleryContent.css('visibility', 'initial')

  _setSwiperSize: =>
    revealHeight = @$container.height()
    if @$mainSwiper.length > 0
      thumbSwiperHeight = @$galleryContent.find('.thumb-swiper').height()
      revealAvailableHeight = revealHeight - thumbSwiperHeight
      @$mainSwiper.height(revealAvailableHeight)
    else
      @$galleryContent.height(revealHeight)

  _setupYoutube: =>
    embeds = @$container.find('iframe')
    if embeds.length > 0
      if typeof YT == 'undefined'
        # Download YT script and wait until API is ready
        # TODO: Clean up wait hack
        console.log('Downloading YT script')
        $.getScript "https://www.youtube.com/iframe_api", =>
          setTimeout =>
            @_setupEmbeds(embeds)
          , 1500
      else
        @_setupEmbeds(embeds)

  _setupEmbeds: (embeds) =>
    embeds.each (index, element) =>
      player = new YT.Player(element)
      @youtubeEmbeds.push(player)

      @$container.on 'closed.zf.reveal', =>
        @youtubeEmbeds.forEach (element) =>
          element.pauseVideo()

