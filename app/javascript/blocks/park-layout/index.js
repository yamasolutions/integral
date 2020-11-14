import React from 'react';
import ReactDOM from 'react-dom';

import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'

import { image as icon } from '@wordpress/icons';

const name = 'hanazono/park-layout';

export { name };

export const settings = {
	title: 'Park Layout',
	description:  'Display the Hanazono Park Layout taken from Yukiyama.',
  icon,
  category: 'widgets',
  attributes: {
  },
  edit({attributes, className, setAttributes, isSelected}) {
    return (
      <div className='block-preview'>
        <p>Park Layout</p>
        <div className='block-preview--image'>
        </div>
      </div>
    );
  }
};
