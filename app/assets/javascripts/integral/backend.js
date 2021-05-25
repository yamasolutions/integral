// function ready() {
//   $('#resource_form').on('keypress', e => {
//     if (e.keyCode == 13) {
//       return false;
//     }
//   });
//
//   $("[data-form-subscribe-notifications], [data-form-unsubscribe-notifications]").submit(function( event ) {
//     $(event.target).find('.button').attr('disabled', true)
//   });
//
//   $('[data-form-subscribe-notifications]').on( "ajax:success", function(event, response) {
//     activeForm = $(event.target)
//     activeForm.find('.button').attr('disabled', false)
//     activeForm.addClass('hide')
//     $('[data-form-unsubscribe-notifications]').removeClass('hide')
//     toastr['success']('You have subscribed to notifications.')
//   });
//
//   $('[data-form-unsubscribe-notifications]').on( "ajax:success", function(event, response) {
//     activeForm = $(event.target)
//     activeForm.find('.button').attr('disabled', false)
//     activeForm.addClass('hide')
//     $('[data-form-subscribe-notifications]').removeClass('hide')
//     toastr['success']('You have unsubscribed to notifications.')
//   });
//
//
//   if (($('body.lists.new').length > 0) || ($('body.lists.show').length > 0) || ($('body.lists.edit').length > 0)) {
//     new List();
//   }
//
//   // Only allow one permission per role
//   $('.js-table--user-roles input[type=checkbox]').change(function(ev) {
//     if ($(ev.currentTarget).is(':checked')) {
//       $(ev.currentTarget).closest('tr').find('input[type=checkbox]').not(this).prop('checked', false);
//     }
//   });
//
//   // Prompts users if a dirty form exists before allowing them to navigate away from the page
//   $('form.are-you-sure').areYouSure();
//
//   bodyData = $('body').data();
//   window.current_user = {
//     name: bodyData.userName,
//     email: bodyData.userEmail,
//     createdAt: bodyData.userCreatedAt,
//     locale: bodyData.locale
//   };
//
//   // Disable tab index for help text URLs
//   $('.help-text a').attr('tabindex', -1);
//
//   // Prompts users of dirty forms before allowing them to navigate away from the page
//   $('[data-confirm-dirty-form]').areYouSure();
//
//   // For small devices close the sidebar menu when a user navigates away from the page.
//   // Prevents issues when user navigates back to that page
//   if (Foundation.MediaQuery.is('small down')) {
//     $('#app-dashboard-sidebar ul li:not(.is-accordion-submenu-parent) a').on('click', function() {
//       $('#app-dashboard-sidebar').foundation('close');
//     });
//   }
//
//   // Set the locale for clientside validations
//   I18n.locale = $('body').data('locale') || 'en';
//
//   // Used for Autocomplete
//   var filterSuggestions = function(suggestableInput, suggestions) {
//     existingItems = suggestableInput.val().split(',');
//
//       return suggestions.filter( function( el ) {
//         return existingItems.indexOf( el ) < 0;
//       });
//   };
//
//   // Material Tags
//   $("[data-suggest-tags]").each(function( index ) {
//     suggestableInput = $(this);
//     typeaheadSuggestions = suggestableInput.data('suggestTagsTypeahead').split(' ');
//     freeInput = suggestableInput.data('suggestTagsFreeInput');
//
//     if (typeof freeInput === 'undefined') {
//       freeInput = true;
//     }
//
//     // Initialize suggest engine
//     suggestEngine = new Bloodhound({
//       datumTokenizer: Bloodhound.tokenizers.whitespace,
//       queryTokenizer: Bloodhound.tokenizers.whitespace,
//       local: typeaheadSuggestions
//     });
//
//     // Initialize materialtags
//     suggestableInput.materialtags({
//       freeInput: freeInput,
//       typeaheadjs: {
//         source: function(query, cb) {
//           suggestEngine.search(query, function(suggestions) {
//             cb(filterSuggestions(suggestableInput, suggestions));
//           });
//         },
//         // TODO: These two options don't currently work but would be nice to add in
//         autoselect: true,
//         highlight: true
//       }
//     });
//   });
// };
