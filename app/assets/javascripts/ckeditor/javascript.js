//= require jquery
//= require jquery_ujs
//= require foundation

/*
 * Default CKEditor Embedded Javascript
 *
 * Override this file to embed Javascript into CKeditor instances.
 * Reasons for overriding could include;
 * - Initializing frameworks such as Foundation or Bootstrap
 * - Adding custom JS also present on frontend
 *   Adding JS to interact with editors only
 *
**/

function ready() {
  if (window.initialized == true) {
    return;
  } else {
    window.initialized = true
  }

  // Initialize foundation
  $(document).foundation();
};

$( document ).ready(ready);
