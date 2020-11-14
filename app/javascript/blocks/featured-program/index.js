import React from 'react';
import ReactDOM from 'react-dom';

import { registerBlockStyle } from '@wordpress/blocks';
import { createBlock } from '@wordpress/blocks';
import { rawHandler } from '@wordpress/blocks';

import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import { InspectorControls, RichText, MediaUpload, PlainText } from '@wordpress/block-editor'

const name = 'integral/featured-program'

export { name };

export const settings = {
	title: 'Featured Program',
	description:  'Highlight a featured program.',
  icon: 'id-alt',
  category: 'formatting',
	styles: [
		{ name: 'light', label: 'Light', isDefault: true },
		{ name: 'dark', label: 'Dark' }
	],
  attributes: {
    title: {
      source: 'text',
      selector: '.featured-program__title'
    },
    imageAlt: {
      attribute: 'alt',
      selector: '.featured-program__image'
    },
    imageUrl: {
      attribute: 'src',
      selector: '.featured-program__image'
    },
    url: {
      type: 'text'
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
                Edit
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
    return ([
      <InspectorControls>
				<PanelBody title='Settings'>
          <TextControl
            label="URL"
            value={ attributes.url }
            onChange={ content => setAttributes({ url: content }) }
          />
				</PanelBody>
      </InspectorControls>,
      <div className={ 'featured-program ' + className }>
        <div className="featured-program__anchor">
          <MediaUpload
            onSelect={ media => { setAttributes({ imageAlt: media.alt, imageUrl: media.url }); } }
            type="image"
            value={ attributes.imageID }
            render={ ({ open }) => getImageButton(open) }
          />
        </div>
        <PlainText
          onChange={ content => setAttributes({ title: content }) }
          value={ attributes.title }
          placeholder="Your progam title"
          className="featured-program__title pointer-events-all"
        />
      </div>
    ]);
  },
  save({ attributes }) {
    const cardImage = (src, alt) => {
      if(!src) return null;

      return (
        <img
          className="featured-program__image"
          src={ src }
          alt={ alt }
        />
      );
    }

    return (
      <div className="featured-program">
          <a className="featured-program__anchor" href={ attributes.url }>
            { cardImage(attributes.imageUrl, attributes.imageAlt) }
          </a>
          <h3 className="featured-program__title">
            { attributes.title }
          </h3>
      </div>
    );
  }
};
