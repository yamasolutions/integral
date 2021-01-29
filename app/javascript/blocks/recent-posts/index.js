import React from 'react';
import ReactDOM from 'react-dom';

import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'

import { postList as icon } from '@wordpress/icons';

const name = 'integral/recent-posts';

export { name };

export const settings = {
	title: 'Recent Posts',
	description:  'Display a list of latest posts.',
  icon,
  category: 'widgets',
  attributes: {
    categories: {
      type: 'text'
    },
    tags: {
      type: 'text'
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {
    return ([
      <InspectorControls>
				<PanelBody title='Widget settings'>
          <TextControl
            label="Categories"
            value={ attributes.categories }
            onChange={ content => setAttributes({ categories: content }) }
            help='Seperated by commas'
          />
          <TextControl
            label="Tags"
            value={ attributes.tags }
            onChange={ content => setAttributes({ tags: content }) }
            help='Seperated by commas'
          />
				</PanelBody>
      </InspectorControls>,
      <div className={ className }>
        <p>Recent Posts</p>
        <div className='post-outline'>
          <div className='post-outline--header'>
            <div className='post-outline--image'></div>
            <div className='post-outline--title'></div>
          </div>
          <div className='post-outline--description-line-1'></div>
          <div className='post-outline--description-line-2'></div>
          <div className='post-outline--description-line-3'></div>
        </div>
      </div>
    ]);
  }
};
