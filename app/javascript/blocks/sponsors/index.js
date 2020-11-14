import React from 'react';
import ReactDOM from 'react-dom';

import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'

import { people as icon } from '@wordpress/icons';

const name = 'hanazono/sponsors';

export { name };

export const settings = {
	title: 'Sponsors',
	description:  'Display a sponsors slider.',
  icon,
  category: 'widgets',
  attributes: {
    list_id: {
      type: 'text',
      default: 23
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {
    return ([
      <InspectorControls>
				<PanelBody title='Widget settings'>
          <TextControl
            label="List ID"
            value={ attributes.list_id }
            onChange={ content => setAttributes({ list_id: content }) }
            help='The backend list to pull the sponsors from.'
          />
				</PanelBody>
      </InspectorControls>,
      <div className='block-preview'>
        <p>Sponsors</p>
        <div className='block-preview--image'>
        </div>
      </div>
    ]);
  }
};
