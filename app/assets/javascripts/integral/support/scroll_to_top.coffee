# Handles interaction with scrollToTop widget.
# Shows widget when user begins to scroll and scrolls user to the top of the page
# when widget is clicked.
class this.ScrollToTop
  @init: ->
    scrollToTop = $('#toTop')
    scrollWindow = $(window)

    scrollWindow.scroll =>
      if scrollWindow.scrollTop() > 10
        scrollToTop.fadeIn()
      else
        scrollToTop.fadeOut()

    scrollToTop.on 'click', =>
      $("html, body").animate({ scrollTop: 0 }, 600)
      return false
