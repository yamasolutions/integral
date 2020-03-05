CKEDITOR.plugins.add( 'foundation-callout', {
  requires: 'widget',

  init: function( editor ) {
    editor.addCommand('copywidget', {
      modes: { wysiwyg: 1, source: 0 },
      exec: function(editor) {
        if (self.TargetWidget != null) {
          self.TargetWidget.focus();
          editor.execCommand( 'copy' );
        }
      },
      canUndo: true
    });

    editor.addCommand('removewidget', {
      modes: { wysiwyg: 1, source: 0 },
      exec: function(editor) {
        if (self.TargetWidget != null) {
          var Element = self.TargetWidget.element;
          self.TargetWidget.destroy();
          Element.remove();
        }
      },
      canUndo: true
    });

    if (editor.addMenuItems) {
      editor.addMenuGroup('widget');

      var IconPath = this.path + 'icons/' + (CKEDITOR.env.hidpi ? 'hidpi/' : '');
      CKEDITOR.skin.addIcon('widget', IconPath + 'widget.png');
      CKEDITOR.skin.addIcon('copywidget', IconPath + 'copywidget.png');
      CKEDITOR.skin.addIcon('removewidget', IconPath + 'removewidget.png');

      editor.addMenuItems({
        widget: {
          label: 'Widget',
          group: 'widget',
          getItems: function() {
            var MenuItems = {};
            MenuItems.copywidget = CKEDITOR.TRISTATE_OFF;
            MenuItems.removewidget = CKEDITOR.TRISTATE_OFF;
            return MenuItems;
          }
        },
        copywidget: {
          label: 'Copy',
          icon: 'copywidget',
          group: 'widget',
          command: 'copywidget'
        },
        removewidget: {
          label: 'Remove',
          icon: 'removewidget',
          group: 'widget',
          command: 'removewidget'
        }
      });
    }

    if (editor.contextMenu) {
      editor.contextMenu.addListener(function(element, selection) {
        self.TargetWidget = editor.widgets.widgetHoldingFocusedEditable || editor.widgets.focused;

        if (self.TargetWidget != null && self.TargetWidget.name == 'foundation-callout') {
          var WidgetMenuItem = editor.getMenuItem('widget');
          WidgetMenuItem.label = 'Callout';
          return {
            widget: CKEDITOR.TRISTATE_OFF
          };
        }
      });
    }

    editor.widgets.add( 'foundation-callout', {
      editables: {
        anything: '*'
      },

      upcast: function( element ) {
        return element.name == 'div' && element.hasClass( 'callout' );
      }
    } );
  }
} );
