import React from 'react'
import ReactDOM from 'react-dom'

import {
	InnerBlocks
} from '@wordpress/block-editor';
import { registerBlockStyle } from '@wordpress/blocks';

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
  }
};

