import React from 'react'
import ReactDOM from 'react-dom'

import {
	InnerBlocks
} from '@wordpress/block-editor';
import { registerBlockStyle } from '@wordpress/blocks';
import { createBlock } from '@wordpress/blocks';
import { rawHandler } from '@wordpress/blocks';

const name = 'integral/foundation-callout';

export { name };

export const settings = {
	title: 'Callout',
	description:  'Container to help draw attention to content.',
  icon: 'universal-access-alt',
  category: 'layout',
	styles: [
		{ name: 'default', label: 'Default', isDefault: true },
		{ name: 'primary', label: 'Primary' },
		{ name: 'secondary', label: 'Secondary' }
	],
  example: {
    innerBlocks: [
      {
        name: 'core/paragraph',
        attributes: {
          content: 'Use a callout to grab the users attention.'
        }
      }
    ]
  },
  edit(props) {
    return (
      <div className={ 'callout ' + props.className }>
        <InnerBlocks/>
      </div>
    );
  },
  save() {
    return <div className='callout'><InnerBlocks.Content /></div>;
  },
  transforms: {
    from: [
      {
        type: 'raw',
        priority: 1,
        selector: 'div.callout, div.info-box, div.buy-box',
        transform( node ) {
          return createBlock( 'integral/foundation-callout', {}, rawHandler({ HTML: node.innerHTML }));
        },
      },
    ],
  }
};

