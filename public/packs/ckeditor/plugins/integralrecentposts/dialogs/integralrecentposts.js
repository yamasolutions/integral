CKEDITOR.dialog.add('integralrecentposts', function( editor ) {
  return {
    title: 'Recent Posts Widget',
    minWidth: 200,
    minHeight: 100,
    contents: [
      {
        id: 'info',
        elements: [
          {
            id: 'tagged',
            type: 'text',
            min: 1,
            label: 'Filter by tags (comma seperated) - leave blank for no filter',
            width: '100px',
            setup: function( widget ) {
              this.setValue( widget.data.tagged );
            },
            commit: function( widget ) {
              widget.setData( 'tagged', this.getValue() );
            }
          },
          {
            id: 'amount',
            type: 'number',
            min: 1,
            label: 'Maxmimum amount to display - leave blank for default',
            width: '50px',
            setup: function( widget ) {
              this.setValue( widget.data.amount );
            },
            commit: function( widget ) {
              widget.setData( 'amount', this.getValue() );
            }
          },
        ]
      }
    ]
  };
} );
