//= require jquery
//= require rails-ujs
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require foundation
//= require i18n
//= require i18n/translations
//= require toastr
//= require rails.validations
//= require rails.validations.simple_form
//= require integral/support/lib/lazysizes
//= require integral/support/ls.twitter
//= require integral/support/ls.instagram
//= require integral/support/date_picker
//= require integral/support/date_picker
//= require integral/support/click_to_copy
//= require integral/support/google_analytics
//= require integral/support/header_anchors
//= require integral/support/scroll_to_top
//= require integral/support/remote_form

// Initialize Page
function ready() {
  if (window.initialized == true) {
    return;
  } else {
    window.initialized = true;
  }

  // Initialize foundation
  $(document).foundation();

  ClickToCopy.init();
  ScrollToTop.init();
  HeaderAnchors.init();
  new RemoteForm($('.remote-form'));
  new DatePicker('.datepicker');
  GoogleAnalytics.trackRead();

  // Move most read posts widget to middle of post listing (can't do this serverside due to caching)
  $mostReadWidget = $('[data-most-read-posts]');
  if ($mostReadWidget.length == 1) {
    $('[data-most-read-posts]').insertAfter('[data-post-list] div:nth-child(5)');
  }

  // Scroll Container
  // TODO
  // in future allow to configure each scroll-container how it activiates
  // also update when changing size
  $(".scroll-container").each(function( index ) {
    container = $(this);
    wrapper = container.find('.scroll-wrapper');
    visibleChildren = wrapper.children(':visible');
    //elementWidth = '250';
    elementWidth = parseInt(container.data('item-width'))

    validSizes = ['small', 'medium']
    //if (Foundation.MediaQuery.current == 'small') {
    if (validSizes.includes(Foundation.MediaQuery.current)) {

      visibleChildren.each(function(index) {
        $(this).css('width', elementWidth);
        $(this).css('max-width', 'unset');
      });

      firstChild = visibleChildren.first()
      wrapperWidth = (elementWidth + (parseInt(firstChild.css('marginLeft')) + parseInt(firstChild.css('marginRight')))) * visibleChildren.size();
      widthCss = wrapperWidth + 'px';
      wrapper.css('width', widthCss);
    }
  });
};

// Initial Page load event handler
$(document).ready(ready);

// User navigates using Turbolinks
document.addEventListener("turbolinks:load", ready);

// User navigates using Turbolinks
document.addEventListener("turbolinks:visit", function() {
  window.initialized = false;
});

document.addEventListener("turbolinks:render", function() {
  GoogleAnalytics.virtualPageView();

  // Fix Sticky for TL
  setTimeout(function(){
    $(window).trigger('load.zf.sticky');
  }, 2000);
});


