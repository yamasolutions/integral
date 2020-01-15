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


