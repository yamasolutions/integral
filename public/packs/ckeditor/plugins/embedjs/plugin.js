/**
 * @file
 * CKEditor plugin to inject custom JavaScript into the WYSIWYG iframe.
 * Based of this post - https://www.drupal.org/project/wysiwyg_custom_js
 */

CKEDITOR.plugins.add('embedjs', {
  init : function (editor) {

    /**
     * Add JavaScript to the WYSIWYG iframe whenever it is loaded.
     */
    editor.on('mode', function(event) {
      if (event.editor.mode == 'wysiwyg') {
        var iframe = getIframe(event.editor);
        var scriptFiles = getJavascriptFiles(event.editor.config);

        // Inject scripts
        if (scriptFiles.length > 0) {
          injectIframeScriptsInOrder(iframe, scriptFiles);
        }
      }
    });

    /**
     * Retrieves the WYSIWYG iframe from a CKEditor editor object.
     *
     * @return
     *   The DOM node corresponding to the WYSIWYG iframe associated with the
     *   provided editor.
     */
    var getIframe = function (editor_object) {
      return jQuery('#' + editor_object.id + '_contents iframe').get(0);
    };

    /**
     * Retrieves the Javascript file URL if it has been provided
     *
     * @return
     *  Array object of files to be injected. Can either be empty or the provided file in config
     */
    var getJavascriptFiles = function (config) {
      if ((typeof config.embedjs == 'undefined') || (typeof config.embedjs.file == 'undefined' )) {
        return [];
      }
      else {
        return [config.embedjs.file];
      }
    };

    /**
     * Injects JavaScript into an iframe in a specified order.
     *
     * This function injects JavaScript files and inline JavaScript into an
     * existing iframe while ensuring that the correct order is preserved so
     * that dependencies are met. After everything has been injected and
     * finished loading, a callback is triggered.
     *
     * @param iframe
     *   The DOM node corresponding to the iframe.
     * @param array script_files
     *   An array of filenames representing the JavaScript files to load, in
     *   the order in which they should be loaded.
     * @param string inline_script
     *   A string representing JavaScript code that should be executed inline.
     *   This code will run after all the above JavaScript files have been
     *   loaded.
     * @param callback
     *   A callback function to run after all JavaScript has been added and
     *   finished loading. This function will be passed the iframe DOM node as
     *   the first and only parameter.
     */
    var injectIframeScriptsInOrder = function (iframe, script_files, inline_script, callback) {
      var iframe_document = iframe.contentWindow.document;

      // Clone the list of script files to prevent this function from modifying
      // the version that the calling code sees.
      var scripts = script_files.slice(0);

      // Create a script element for the first JavaScript file, then add an
      // onload handler to recursively trigger this function for the next file
      // once the first is finished loading. In the case of JavaScript which is
      // dynamically injected after the iframe has finished loading, this
      // ensures that the JavaScript files load in the correct order such that
      // any dependencies are met. Parts of this code are roughly based on the
      // example at http://stackoverflow.com/questions/16230886/trying-to-fire-onload-event-on-script-tag/16231055.
      var script_element = iframe_document.createElement('script');
      script_element.type = 'text/javascript';
      script_element.src = scripts.shift();
      script_element.onload = function () {
        if (scripts.length) {
          injectIframeScriptsInOrder(iframe, scripts, inline_script, callback);
        }
        else {
          // All the script files have finished loading, so add the inline
          // scripts afterwards.
          var inline_script_element = iframe_document.createElement('script');
          inline_script_element.type = 'text/javascript';
          inline_script_element.appendChild(iframe_document.createTextNode(inline_script));
          iframe_document.head.appendChild(inline_script_element);
          // Finally, execute the callback function if one was supplied
          if (typeof callback !== 'undefined') {
            callback(iframe);
          }
        }
     };
     iframe_document.head.appendChild(script_element);
    };
  }
});
