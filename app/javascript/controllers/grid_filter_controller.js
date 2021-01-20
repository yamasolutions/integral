import { Controller } from "stimulus"
import $ from 'jquery'
import 'select2'

export default class extends Controller {
  initialize() {
    $(this.element).select2()

    // Unfortunately no way to disable search through plugin
    var $searchfield = $(this.element).parent().find('.select2-search__field');
    $searchfield.prop('disabled', true);
    $searchfield.css("display", "none");

    // Change events are not being picked up by the Grid class, possibly because it's loaded through Asset Pipeline and using a different instance of jQuery (?)
    // Have to manually submit the form using asset pipelines jQuery instance
    $(this.element).on('change', (event, manualCheck) => {
      window.jQuery(this.element).closest('form').submit()
    })

    // Hides dropdown on unselect - https://github.com/select2/select2/issues/3320
    $(this.element).on("select2:unselect", function (evt) {
      $(this).on("select2:opening.cancelOpen", function (evt) {
        evt.preventDefault();

        $(this).off("select2:opening.cancelOpen");
      });
    });

    // Unfortunately no way to disable search through plugin
    $(this.element).on('select2:opening select2:closing', function( event ) {
      var $searchfield = $(this).parent().find('.select2-search__field');
      $searchfield.prop('disabled', true);
      $searchfield.css("display", "none");
    });
  }
}
