import React from 'react'
import ReactDOM from 'react-dom'

import {
	// InspectorControls,
	InnerBlocks
	// BlockControls,
	// BlockVerticalAlignmentToolbar,
	// __experimentalBlockVariationPicker,
	// __experimentalBlock as Block,
} from '@wordpress/block-editor';
import { registerBlockStyle } from '@wordpress/blocks';

const name = 'integral/foundation-callout';

// TODO: Move these into settings
registerBlockStyle( 'integral/foundation-callout', {
    name: 'primary',
    label: 'Primary',
} );

registerBlockStyle( 'integral/foundation-callout', {
    name: 'secondary',
    label: 'Secondary'
} );

export { name };

export const settings = {
	title: 'Callout',
	description:  'Container to help draw attention to content.',
  icon: 'universal-access-alt',
  category: 'layout',
  edit(props) {
    return (
      <div className={ 'callout ' + props.className }>
        <InnerBlocks/>
      </div>
    );
  },
  save() {
    return <div className='callout'><InnerBlocks.Content /></div>;
  }

  		// 	<InnerBlocks
			// 	allowedBlocks={ ALLOWED_BLOCKS }
			// 	__experimentalMoverDirection="horizontal"
			// 	__experimentalTagName={ Block.div }
			// 	__experimentalPassedProps={ {
			// 		className: classes,
			// 	} }
			// 	renderAppender={ false }
			// />
      //

	// keywords: [ __( 'text' ) ],
	// example: {
	// 	attributes: {
	// 		content: __(
	// 			'In a village of La Mancha, the name of which I have no desire to call to mind, there lived not long since one of those gentlemen that keep a lance in the lance-rack, an old buckler, a lean hack, and a greyhound for coursing.'
	// 		),
	// 		style: {
	// 			typography: {
	// 				fontSize: 28,
	// 			},
	// 		},
	// 		dropCap: true,
	// 	},
	// },
	// supports: {
	// 	className: false,
	// 	__unstablePasteTextInline: true,
	// 	lightBlockWrapper: true,
	// 	__experimentalColor: Platform.OS === 'web',
	// 	__experimentalLineHeight: true,
	// 	__experimentalFontSize: true,
	// },
	// __experimentalLabel( attributes, { context } ) {
	// 	if ( context === 'accessibility' ) {
	// 		const { content } = attributes;
	// 		return isEmpty( content ) ? __( 'Empty' ) : content;
	// 	}
	// },
	// transforms,
	// deprecated,
	// merge( attributes, attributesToMerge ) {
	// 	return {
	// 		content:
	// 			( attributes.content || '' ) +
	// 			( attributesToMerge.content || '' ),
	// 	};
	// },
	// edit,
	// save,
};

