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
import { cover as icon } from '@wordpress/icons';

const BLOCKS_TEMPLATE = [
    [ 'core/heading', { content: 'Cover Title' } ],
    [ 'core/list', { values: '<li>Example list item 1</li><li>Example list item 2</li><li>Example list item 3</li>' } ],
];
const ALLOWED_BLOCKS = [ 'core/heading', 'core/paragraph', 'core/list' ];
const name = 'integral/cover';

export { name };

export const settings = {
	title: 'Cover',
	description:  'Add an image with a text overlay - great for breaking up content.',
  icon,
  category: 'formatting',
	styles: [
		{ name: 'left', label: 'Left Side', isDefault: true },
		{ name: 'right', label: 'Right Side' }
  ],
  // example: {
  //   innerBlocks: [
  //     {
  //       name: 'core/paragraph',
  //       attributes: {
  //         content: 'Use a callout to grab the users attention.'
  //       }
  //     }
  //   ]
  // },
  attributes: {
    imageAlt: {
      attribute: 'alt',
      selector: '.card__image'
    },
    imageUrl: {
      attribute: 'src',
      selector: '.card__image'
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {
    const getImageButton = (openEvent) => {
      if(attributes.imageUrl) {
        return (
          <>
            { isSelected &&
              <Button
                onClick={ openEvent }
                className="button"
                >
                Edit image
              </Button>
            }
            <img
              src={ attributes.imageUrl }
              className="card__image"
            />
          </>
        );
      }
      else {
        return (
          <div className="block-editor-image-placeholder">
            <Button
              onClick={ openEvent }
              className="button button-large"
            >
            Pick an image
            </Button>
          </div>
        );
      }
    };
    return (
      <div className={ className }>
        <MediaUpload
          onSelect={ media => { setAttributes({ imageAlt: media.alt, imageUrl: media.url }); } }
          type="image"
          value={ attributes.imageID }
          render={ ({ open }) => getImageButton(open) }
        />
        <div className='integral-cover-card'>
          <InnerBlocks
            allowedBlocks={ ALLOWED_BLOCKS }
            template={ BLOCKS_TEMPLATE }
          />
        </div>
      </div>
    );
  },
  save({ attributes }) {
    const cardImage = (src, alt) => {
      if(!src) return null;

      return (
        <img
          className="integral-cover-image"
          src={ src }
          alt={ alt }
        />
      );
    }

    return (
      <div>
        { cardImage(attributes.imageUrl, attributes.imageAlt) }
        <div className='integral-cover-card'>
          <InnerBlocks.Content />
        </div>
      </div>
    );
  },
};
