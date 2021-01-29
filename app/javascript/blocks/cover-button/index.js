import React from 'react';
import ReactDOM from 'react-dom';

import {
	InnerBlocks
} from '@wordpress/block-editor';
import { registerBlockStyle } from '@wordpress/blocks';
import { createBlock } from '@wordpress/blocks';
import { rawHandler } from '@wordpress/blocks';

import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'
import { link as icon } from '@wordpress/icons';

const name = 'integral/cover-button';

export { name };

export const settings = {
	title: 'Cover button',
	description:  'Add a call to action to your cover section.',
  icon,
  category: 'formatting',
  parent: [ 'integral/cover' ],
  attributes: {
    title: {
      type: 'text'
    },
    url: {
      type: 'text'
    },
    openInNewTab: {
      type: 'boolean'
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {

    return ([
      <InspectorControls>
				<PanelBody title='Button settings'>
          <TextControl
            label="URL"
            value={ attributes.url }
            onChange={ content => setAttributes({ url: content }) }
          />
          { attributes.url && (
            <ToggleControl
              label="Open in new Tab?"
              checked={ attributes.openInNewTab }
              onChange={ content => setAttributes({ openInNewTab: content }) }
            />
          )}
				</PanelBody>
      </InspectorControls>,

      <PlainText
        onChange={ content => setAttributes({ title: content }) }
        value={ attributes.title }
        placeholder="Enter text"
        className="wp-block-integral-cover-button"
      />
    ]);
  },
  save({ attributes }) {
    const linkTarget = (attributes.openInNewTab) ? '_blank' : '_self';

    return (
      <a
        href= { attributes.url }
        target= { linkTarget }>
      { attributes.title }
      </a>
    );
  },
};
