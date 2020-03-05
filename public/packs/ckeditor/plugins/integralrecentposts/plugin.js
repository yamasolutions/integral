CKEDITOR.plugins.add( 'integralrecentposts', {
  requires: 'widget',

  init: function( editor ) {
    CKEDITOR.dialog.add( 'integralrecentposts', this.path + 'dialogs/integralrecentposts.js' );
    editor.widgets.add( 'integralrecentposts', {
      dialog: 'integralrecentposts',
      template:
      '<p class="integral-widget" ' +
      'data-widget-type="recent_posts" ' +
      'data-widget-value-amount="" ' +
      'data-widget-value-tagged="" ' +
      '>Recent Posts</p>',

      init: function() {
        this.setData('amount', this.element.data('widget-value-amount'));
        this.setData('tagged', this.element.data('widget-value-tagged'));
      },
      data: function() {
        if (this.data.amount != null) {
          this.element.data('widget-value-amount', this.data.amount);
        }
        if (this.data.tagged != null) {
          this.element.data('widget-value-tagged', this.data.tagged);
        }
      },
      upcast: function( element ) {
        return element.name == 'p' && element.hasClass('integral-widget') && element.attributes['data-widget-type'] == 'recent_posts'
      }
    });
  }
});
