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

const name = 'integral/card'; // Add foundation prefix?

export { name };

export const settings = {
	title: 'Card',
	description:  'Group a piece of content in an eye catching container.',
  icon: 'id-alt',
  category: 'formatting',
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
    title: {
      source: 'text',
      selector: '.card__title'
    },
    body: {
      type: 'array',
      source: 'children',
      selector: '.card__body'
    },
    imageAlt: {
      attribute: 'alt',
      selector: '.card__image'
    },
    imageUrl: {
      attribute: 'src',
      selector: '.card__image'
    },
    hasCallToAction: {
      type: 'boolean'
    },
    callToAction: {
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
				<PanelBody title='Card settings'>
          <TextControl
            label="URL"
            value={ attributes.url }
            onChange={ content => setAttributes({ url: content }) }
          />
          { attributes.url && (
            <ToggleControl
              label="Display Call To Action"
              checked={ attributes.hasCallToAction }
              onChange={ content => setAttributes({ hasCallToAction: content }) }
            />
          )}
          { attributes.url && (
            <ToggleControl
              label="Open in new Tab?"
              checked={ attributes.openInNewTab }
              onChange={ content => setAttributes({ openInNewTab: content }) }
            />
          )}
				</PanelBody>
      </InspectorControls>,
      <div className={ 'card ' + className }>
        <MediaUpload
          onSelect={ media => { setAttributes({ imageAlt: media.alt, imageUrl: media.url }); } }
          type="image"
          value={ attributes.imageID }
          render={ ({ open }) => getImageButton(open) }
        />
        <div className='card-section'>
          <PlainText
            onChange={ content => setAttributes({ title: content }) }
            value={ attributes.title }
            placeholder="Your card title"
            className="card__title"
          />
          <hr className='card__divider' />
          <RichText
            onChange={ content => setAttributes({ body: content }) }
            value={ attributes.body }
            multiline="p"
            placeholder="Your card text"
          />
        </div>
      { attributes.hasCallToAction && attributes.url &&
        <PlainText
          onChange={ content => setAttributes({ callToAction: content }) }
          value={ attributes.callToAction }
          placeholder="Your Call To Action"
          className="button expanded"
        />
      }
      </div>
    ]);
  },
  save({ attributes }) {
    const linkTarget = (attributes.openInNewTab) ? '_blank' : '_self';
    const cardImage = (src, alt) => {
      if(!src) return null;

      return (
        <img
          className="card__image"
          src={ src }
          alt={ alt }
        />
      );
    }

    return (
      <div className="card">
        { attributes.url ? (
          <a
            href={ attributes.url }
            target= { linkTarget }
          >
            { cardImage(attributes.imageUrl, attributes.imageAlt) }
          </a>
        ) : (
          cardImage(attributes.imageUrl, attributes.imageAlt)
        )}
        <div className="card-section">
          <h3 className="card__title">
            { attributes.url ? (
              <a
                href={ attributes.url }
                target= { linkTarget }
              >
                { attributes.title }
              </a>
            ) : (
              attributes.title
            )}
          </h3>
          <hr className='card__divider'/>
          <div className='card__body'>
            { attributes.body }
          </div>
        </div>
      { attributes.hasCallToAction && attributes.url &&
        <RichText.Content
          tagName="a"
          className='button expanded'
          href={ attributes.url }
          target= { linkTarget }
          value={ attributes.callToAction }
        />
      }
      </div>
    );
  }
};
