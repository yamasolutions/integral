// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require nprogress
//= require nprogress-turbolinks
//= require toastr
//= require rails.validations
//= require rails.validations.simple_form
//= require parsley
//= require cocoon
//= require ckeditor/loader
//= require i18n
//= require i18n/translations
//= require_directory ./support
//= require ./support/lib/underscore
//= require ./support/lib/html.sortable
//= require ./support/lib/jquery_form
//= require ./support/lib/jquery.are-you-sure
//= require ./support/lib/js.cookie
//= require ./support/lib/typeahead
//= require ./support/lib/materialize-tags
//= require_directory ./backend/support
//= require integral/backend/extensions

function ready() {
  if (window.initialized == true) {
    return;
  } else {
    window.initialized = true;
  }

  function loadMore(entries) {
    if (entries[0].intersectionRatio <= 0) {
      return;
    }
    lastNotificationObserver.unobserve(notificationsContainer.find('ul li:last-of-type')[0])

    $.ajax({
      url: notificationsContainer.data('load-more-url'),
      success: function(response) {
        notificationsContainer.find('ul').append(response.content)
        $('[data-notification-read-url]').each(function( index, notification ) {
          unreadNotificationObserver.unobserve(notification)
          unreadNotificationObserver.observe(notification)
        });

        if (response.load_more_url) {
          notificationsContainer.data('load-more-url', response.load_more_url)
          lastNotificationObserver.observe(notificationsContainer.find('ul li:last-of-type')[0])
        } else {
          notificationsContainer.find('.js-loader--notifications').hide()
        }
      }
    });
  }

  function readNotification(entries) {
    var i;
    for (i = 0; i < entries.length; i++) {
      entry = entries[i]

      if (entry.intersectionRatio < .90) {
        continue;
      }

      readUrl = entry.target.dataset.notificationReadUrl

      unreadNotificationObserver.unobserve(entry.target)
      entry.target.removeAttribute('data-notification-read-url')

      $.ajax({
        url: readUrl,
        type: 'PUT',
        success: function(response) {
        }
      });
    }
  }

  $(document).foundation();
  jQuery('input, textarea').characterCounter();
  SlugGenerator.check_for_slugs();
  RecordSelector.init();
  new ImageSelector();
  new ChartManager();
  NotificationManager.flash();
  ImageUploader.init();
  new RemoteForm($('.remote-form'));
  Grid.init();

  $("[data-form-subscribe-notifications], [data-form-unsubscribe-notifications]").submit(function( event ) {
    $(event.target).find('.button').attr('disabled', true)
  });

  $('[data-form-subscribe-notifications]').on( "ajax:success", function(event, response) {
    activeForm = $(event.target)
    activeForm.find('.button').attr('disabled', false)
    activeForm.addClass('hide')
    $('[data-form-unsubscribe-notifications]').removeClass('hide')
    toastr['success']('You have subscribed to notifications.')
  });

  $('[data-form-unsubscribe-notifications]').on( "ajax:success", function(event, response) {
    activeForm = $(event.target)
    activeForm.find('.button').attr('disabled', false)
    activeForm.addClass('hide')
    $('[data-form-subscribe-notifications]').removeClass('hide')
    toastr['success']('You have unsubscribed to notifications.')
  });

  notificationsContainer = $('[data-notifications]')
  if (notificationsContainer.data('load-more-url')) {
    lastNotificationObserver = new IntersectionObserver(loadMore, { root: notificationsContainer[0] });
    lastNotificationObserver.observe(notificationsContainer.find('ul li:last-of-type')[0])
  }

  unreadNotificationObserver = new IntersectionObserver(readNotification, { root: notificationsContainer[0], threshold: 0.90 });
  $('[data-notification-read-url]').each(function( index, notification ) {
    unreadNotificationObserver.observe(notification)
  });

  // Recent activity 'view more' behaviour
  $("[data-recent-activity]").on("click", function(ev) {
    $button = $(ev.currentTarget);
    modalId = $button.data('container-id');

    $modal = $('#' + modalId);
    if ($modal.length > 0) {
      $modal.foundation('open');
    } else {
      $modal = $('#activity-placeholder').clone().appendTo('body')
      $form = $modal.find('form')
      $modal.attr('id', modalId)
      $modal.foundation()

      // Populate modal with content & filters
      $modal.find('[data-title]').html($button.data('recent-activity-title'))
      $modal.find('[data-timeline]').html($button.closest('.card').find('.timeline').html())
      $form.find("input[name='grid[user]']").val($button.data('recent-activity-user'))
      $form.find("input[name='grid[object]']").val($button.data('recent-activity-object'))
      $form.find("input[name='grid[created_at]']").val($button.data('recent-activity-created-at'))
      $form.find("input[name='grid[item_id]']").val($button.data('recent-activity-item-id'))

      $form.on( "ajax:success", function(event, response) {
        if (response.last_created_at != null) {
          $modal.find('[data-timeline]').append(response.content)
          $form.find("input[name='grid[created_at]']").val(response.last_created_at)
        } else {
          $form.find("input[type='submit']").hide()
        }
      });

      $modal.foundation('open')
      $form.submit()
    }
  });

  // Initialize foundation components on filter
  $(".card.listing form").on("ajax:success", function(ev) {
    $(ev.currentTarget).closest('.card.listing').find('[data-grid] table').foundation();
  });

  // Hijack context menu click for rows which have a URL
  $('.card.listing').on('contextmenu', 'tr[data-href]', function(ev) {
    $('#' + ev.currentTarget.dataset.contextMenu).foundation('open');

    return false;
  });

  // Capture clicks on rows which have a URL and visit that URL
  $('.card.listing').on('click', 'tr[data-href]', function(ev) {
    // Do not follow if the click is within a data-toggle
    if (($(ev.target).closest('[data-toggle]').length == 0) && ($(ev.target).closest('[data-dropdown]').length == 0)) {
      document.location = $(ev.currentTarget).data('href');
    }
  });

  $("[data-button-delete-category]").on("ajax:success", function(ev) {
    $(ev.currentTarget).closest('tr').fadeOut();
  });

  $("[data-button-delete-category]").on("ajax:error", function(ev) {
    toastr["error"](I18n.t('integral.remote_form.error'));
  });

  $("#new_category_modal").on("open.zf.reveal", function(ev) {
    $(ev.currentTarget).find('form').enableClientSideValidations();
  });

  $("[data-button-edit-category]").on( "click", function(ev) {
    modalId = '#' + ev.currentTarget.dataset.buttonEditCategory;
    modalUrl = ev.currentTarget.dataset.modalUrl;

    if ($(modalId).length == 0) {
      $.ajax({url: modalUrl, success: function(response){
        $('body').append(response.content);
        modal = $(modalId);
        modal.foundation().foundation('open');
        modal.find('form').enableClientSideValidations();
        new RemoteForm(modal.find('form'));
        SlugGenerator.check_for_slugs();
      }});
    } else {
      $(modalId).foundation('open');
    }
  });

  if (($('body.lists.new').length > 0) || ($('body.lists.show').length > 0) || ($('body.lists.edit').length > 0)) {
    new List();
  }

  // Only allow one permission per role
  $('.js-table--user-roles input[type=checkbox]').change(function(ev) {
    if ($(ev.currentTarget).is(':checked')) {
      $(ev.currentTarget).closest('tr').find('input[type=checkbox]').not(this).prop('checked', false);
    }
  });

  // Prompts users if a dirty form exists before allowing them to navigate away from the page
  $('form.are-you-sure').areYouSure();

  bodyData = $('body').data();
  window.current_user = {
    name: bodyData.userName,
    email: bodyData.userEmail,
    createdAt: bodyData.userCreatedAt,
    locale: bodyData.locale
  };

  // Disable tab index for help text URLs
  $('.help-text a').attr('tabindex', -1);

  // Prompts users of dirty forms before allowing them to navigate away from the page
  $('[data-confirm-dirty-form]').areYouSure();

  // Mark CKEditor containers as loaded to hide loading indicators
  CKEDITOR.on( 'instanceReady', function( evt ) {
    parent = evt.editor.container.$.parentElement;
    $(parent).addClass('loaded');
  });

  // Remove particular inputs from CKEditor dialogs
  CKEDITOR.on( 'dialogDefinition', function( ev ) {
    // Take the dialog name and its definition from the event data.
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;

    if ( dialogName == 'image2' ) {
      var infoTab = dialogDefinition.getContents('info');

      // Remove unused inputs
      infoTab.remove('height');
      infoTab.remove('lock');

      // Do not validate width input
      infoTab.get('width').validate = function() {
        return true;
      }
    }

    // Remove unused inputs for link
    if ( dialogName == 'link' ) {
      var advancedTab = dialogDefinition.getContents('advanced');
      var targetTab = dialogDefinition.getContents('target');
      var linkTargets = targetTab.get('linkTargetType');

      // Remove unhelpful inputs
      advancedTab.remove('download');
      advancedTab.remove('advId');
      advancedTab.remove('advName');
      advancedTab.remove('advLangDir');
      advancedTab.remove('advLangCode');
      advancedTab.remove('advAccessKey');
      advancedTab.remove('advTabIndex');
      advancedTab.remove('advCharset');
      advancedTab.remove('advContentType');
      advancedTab.remove('advRel');
      advancedTab.remove('advRel');

      // Remove unnecessary link target options
      linkTargets['items'] = [['Not Set', ''], ['New Tab/Window', '_blank']];
    }

    if ( dialogName == 'iframe' ) {
      var generalTab = dialogDefinition.getContents('info');

      // Remove unhelpful inputs
      generalTab.remove('scrolling');
      generalTab.remove('frameborder');
      generalTab.remove('name');
      generalTab.remove('title');
      generalTab.remove('longdesc');
    }

    if ( dialogName == 'table' || dialogName == 'tableProperties' ) {
      var advancedTab = dialogDefinition.getContents('advanced');
      var infoTab = dialogDefinition.getContents('info');

      // Remove unhelpful inputs
      advancedTab.remove('advId');
      advancedTab.remove('advLangDir');
      infoTab.remove('txtCellSpace');
      infoTab.remove('txtCellPad');
      infoTab.remove('txtBorder');
      infoTab.remove('txtHeight');

      // Set default width to blank (let CSS set it)
      txtWidth = infoTab.get( 'txtWidth' );
      txtWidth['default'] = '';
    }
  });

  // For small devices close the sidebar menu when a user navigates away from the page.
  // Prevents issues when user navigates back to that page
  if (Foundation.MediaQuery.is('small down')) {
    $('#app-dashboard-sidebar ul li:not(.is-accordion-submenu-parent) a').on('click', function() {
      $('#app-dashboard-sidebar').foundation('close');
    });
  }

  $('[data-app-dashboard-toggle-shrink]').on('click', function(e) {
    e.preventDefault();

    if (Cookies.get('integral-sidebar') == 'shrunk') {
      Cookies.set('integral-sidebar', 'large');
      $(this).parents('.app-dashboard').addClass('shrink-medium').removeClass('shrink-large');
    } else {
      Cookies.set('integral-sidebar', 'shrunk');
      $(this).parents('.app-dashboard').removeClass('shrink-medium').addClass('shrink-large');
    }
  });

  // Set the locale for clientside validations
  I18n.locale = $('body').data('locale') || 'en';

  // CKEditor Initialization
  // TODO: Fork Ckeditor and remove obtrusive JS causing the below to throw warnings
  for(name in CKEDITOR.instances) {
    CKEDITOR.instances[name].destroy(true);
  }

  $('.ckeditor textarea').each(function() {
    editor = $(this);
    options = {
      "language": I18n.locale,
      "bodyClass": editor.data('ckeditor-class'),
      "toolbar": editor.data('ckeditor-toolbar') || 'default'
    }

    CKEDITOR.replace(editor.attr('id'), options);
  });

  // Populate CKeditor with example content
  $(".ckeditor .populate-button").on( "click", function(ev) {
    ev.preventDefault();
    button = $(ev.target);
    exampleContent = button.data('example-content');
    editorId = button.closest('.ckeditor').find('textarea').attr('id');

    CKEDITOR.instances[editorId].setData(exampleContent);
  });

  // Display 'No Data' row for grids which are empty
  $('table.wice-grid').each(function() {
    table = $(this);
    if (table.find('tbody tr').size() < 2) {
      table.find('tr.empty-grid').removeClass('hide');
      table.find('tfoot').addClass('hide');
    }
  });

  // Used for Autocomplete
  var filterSuggestions = function(suggestableInput, suggestions) {
    existingItems = suggestableInput.val().split(',');

      return suggestions.filter( function( el ) {
        return existingItems.indexOf( el ) < 0;
      });
  };

  // Material Tags
  $("[data-suggest-tags]").each(function( index ) {
    suggestableInput = $(this);
    typeaheadSuggestions = suggestableInput.data('suggestTagsTypeahead').split(' ');
    freeInput = suggestableInput.data('suggestTagsFreeInput');

    if (typeof freeInput === 'undefined') {
      freeInput = true;
    }

    // Initialize suggest engine
    suggestEngine = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      local: typeaheadSuggestions
    });

    // Initialize materialtags
    suggestableInput.materialtags({
      freeInput: freeInput,
      typeaheadjs: {
        source: function(query, cb) {
          suggestEngine.search(query, function(suggestions) {
            cb(filterSuggestions(suggestableInput, suggestions));
          });
        },
        // TODO: These two options don't currently work but would be nice to add in
        autoselect: true,
        highlight: true
      }
    });
  });
};

document.addEventListener("turbolinks:load", ready);
$( document ).ready(ready);

// User navigates using Turbolinks
document.addEventListener("turbolinks:visit", function() {
  window.initialized = false;
});

document.addEventListener("turbolinks:render", function() {
  GoogleAnalytics.virtualPageView();
});

