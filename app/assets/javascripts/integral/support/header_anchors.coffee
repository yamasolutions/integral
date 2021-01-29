# Finds all header attributes which have a name and adds a HREF attribute to itself
# Used so that users can link to a particular part of the page by hovering over the header
# https://css-tricks.com/hash-tag-links-padding/#article-header-id-1
class this.HeaderAnchors
  @init: ->
    # Add self links to h2, h3 & h4 anchors
    # This allows users to click the anchor to link to
    $('.wysiwyg-content h2[id], .wysiwyg-content h3[id], .wysiwyg-content h4[id]').each ->
      anchor = document.createElement("a")
      anchor.setAttribute('href', '#' + @id)
      @appendChild(anchor)

    # TL currently has a bug in which it reloads pages when an anchor link for the same page is clicked.
    # Workaround: As long as that link has data-turbolinks=false we don't need to preventDefault
    $('a[href*="#"]:not([href="#"])').each ->
      currentUrl = window.location.origin + window.location.pathname

      # Check if anchor link is linking to the same page
      if /^#/.test(@href) == true or currentUrl == @href.split('#')[0]
        @dataset.turbolinks = false

      # Prevent possible return false which would cause a loop break
      true
