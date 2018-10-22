class this.ResponsiveSwiper
  @init: ->
    for element in $('[data-responsive-swiper]')
      new ResponsiveSwiper($(element))


  constructor: (element) ->
    @_createSwiper(element).insertAfter(element)

  _createSwiper: (element) ->
    swiperClasses = element.data('responsive-swiper-container-classes')
    swiper = $("<div class='#{swiperClasses}'><div class='swiper-container'>
                <div class='swiper-wrapper'></div>
                <div class='swiper-button-prev'></div>
                <div class='swiper-button-next'></div>
                <div class='swiper-pagination'></div></div><div>")
    swiperWrapper = swiper.find('.swiper-wrapper')
    slideContainer = "<div class='swiper-slide'></div>"

    for slide in element.find('[data-responsive-swiper-slide]')
      slideContainer = $("<div class='swiper-slide'></div>")
      slide = $(slide)

      swiperWrapper.append(slideContainer.append(slide.clone()))

    swiper
