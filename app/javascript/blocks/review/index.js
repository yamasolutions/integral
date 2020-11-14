import React from 'react';
import ReactDOM from 'react-dom';

import {
	InnerBlocks
} from '@wordpress/block-editor';
import { registerBlockStyle } from '@wordpress/blocks';
import { createBlock } from '@wordpress/blocks';
import { rawHandler } from '@wordpress/blocks';

import { RangeControl, TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'

const name = 'integral/review';

export { name };

export const settings = {
	title: 'Review',
	description:  'Share a review from a customer.',
  icon: 'star-filled',
  category: 'formatting',
  attributes: {
    title: {
      source: 'text',
      selector: '.card-review__title'
    },
    body: {
      type: 'array',
      source: 'children',
      selector: '.card-review__body'
    },
    rating: {
      type: 'number',
      default: 4
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {
    return ([
      <InspectorControls>
				<PanelBody title='Review settings'>
          <RangeControl
              label="Rating"
              value={ attributes.rating }
              onChange={ ( content ) => setAttributes( { rating: content } ) }
              min={ 3 }
              max={ 5 }
          />
				</PanelBody>
      </InspectorControls>,
      <div className={ 'card-review ' + className }>
        <PlainText
          onChange={ content => setAttributes({ title: content }) }
          value={ attributes.title }
          placeholder="Customer Name, Location"
          className="card-review__title"
        />
        <div className='card-review__rating'>
          {[...Array(attributes.rating)].map((value, index) => {
            return <i className='fa fa-star'></i>
          })}
        </div>
        <RichText
          onChange={ content => setAttributes({ body: content }) }
          value={ attributes.body }
          multiline="p"
          placeholder="Your card text"
        />
      </div>
    ]);
  },
  save({ attributes }) {
    return (
      <div className="card-review">
        <h4 className="card-review__title">
          { attributes.title }
        </h4>
        <div className='card-review__rating'>
          {[...Array(attributes.rating)].map((value, index) => {
            return <i className='fa fa-star'></i>
          })}
        </div>
        <div className='card-review__body'>
          { attributes.body }
        </div>
      </div>
    );
  }
};
