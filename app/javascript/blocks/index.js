/**
 * External dependencies
 */
import React from 'react';
import ReactDOM from 'react-dom';
import classnames from 'classnames';
import { assign } from 'lodash';

/**
 * WordPress dependencies
 */
import '@wordpress/core-data';
import { registerCoreBlocks } from '@wordpress/block-library'
import '@wordpress/block-editor';
import {
  registerBlockType,
  unregisterBlockType,
  registerBlockStyle,
  unregisterBlockStyle,
  unregisterBlockVariation
} from '@wordpress/blocks';
import { createHigherOrderComponent } from '@wordpress/compose'
import { addFilter } from '@wordpress/hooks';

/**
 * Internal dependencies
 */
import * as book_now from './book-now';
import * as featured_program from './featured-program';
import * as callout from './callout';
import * as card from './card';
import * as cover from './cover';
import * as coverButton from './cover-button';
import * as accordion from './accordion';
import * as recentPosts from './recent-posts';
import * as contactForm from './contact-form';
import * as review from './review';
import * as sponsors from './sponsors';
import * as parkLayout from './park-layout';
import ColumnEdit from './column/edit';
import ButtonEdit from './button/edit';
import ImageEdit from './image/edit';
import MediaUpload from '../components/media-upload';

export const registerBlocks = () => {
  const replaceButtonBlockEdit = ( settings, name ) => {
    if ( name !== 'core/button' ) {
      return settings;
    }

    return assign( {}, settings, {
      edit: ButtonEdit, // Removes & replaces some styling options
      attributes: assign( {}, settings.attributes, {
        hasHollowStyle: {
          type: 'boolean',
          default: false
        },
        hasLargeStyle: {
          type: 'boolean',
          default: false
        }
      })
    } );
  }

  const replaceColumnBlockEdit = ( settings, name ) => {
    if ( name !== 'core/column' ) {
      return settings;
    }

    return assign( {}, settings, {
      edit: ColumnEdit // Removes column width options
    } );
  }

  const replaceImageBlockEdit = ( settings, name ) => {
    if ( name !== 'core/image' ) {
      return settings;
    }

    return assign( {}, settings, {
      edit: ImageEdit // Removes ImageSizeControl options
    } );
  }

  const applyExtraClass = ( extraProps, blockType, attributes ) => {
    if ( blockType.name !== 'core/button' ) {
      return extraProps;
    }

    if (attributes.hasLargeStyle) {
      extraProps.className = classnames( extraProps.className, 'large' );
    }

    if (attributes.hasHollowStyle) {
      extraProps.className = classnames( extraProps.className, 'is-style-hollow' );
    }

    return extraProps;
  }

  const withClientIdClassName = createHigherOrderComponent( ( BlockListBlock ) => {
    return ( props ) => {
      if ( props.name !== 'core/button' ) {
        return <BlockListBlock { ...props } />;
      }

      let classNames = '';
      if (props.attributes.hasLargeStyle) {
        classNames = classnames( classNames, 'large' );
      }

      if (props.attributes.hasHollowStyle) {
        classNames = classnames( classNames, 'is-style-hollow' );
      }

      return <BlockListBlock { ...props } className={ classNames } />;
    };
  }, 'withClientIdClassName' );

  const replaceMediaUpload = () => MediaUpload;

  addFilter(
    'editor.BlockListBlock',
    'integral/filters/core-button-block-list',
    withClientIdClassName
  );

  addFilter(
    'blocks.registerBlockType',
    'integral/filters/core-button',
    replaceButtonBlockEdit
  );

  addFilter(
    'blocks.getSaveContent.extraProps',
    'integral/filters/core-button-classes',
    applyExtraClass
  );

  addFilter(
    'blocks.registerBlockType',
    'integral/filters/core-column',
    replaceColumnBlockEdit
  );

  addFilter(
    'blocks.registerBlockType',
    'integral/filters/core-image',
    replaceImageBlockEdit
  );

  addFilter(
    'editor.MediaUpload',
    'integral/filters/media-upload',
    replaceMediaUpload
  );

  // Register WP blocks
  registerCoreBlocks();

  // Unregister WP blocks which are not supported
  unregisterBlockType('core/gallery');
  unregisterBlockType('core/quote');
  unregisterBlockType('core/shortcode');
  unregisterBlockType('core/archives');
  unregisterBlockType('core/audio');
  unregisterBlockType('core/calendar');
  unregisterBlockType('core/categories');
  unregisterBlockType('core/code');
  unregisterBlockType('core/cover');
  unregisterBlockType('core/embed');
  unregisterBlockType('core-embed/twitter');
  unregisterBlockType('core-embed/youtube');
  unregisterBlockType('core-embed/facebook');
  unregisterBlockType('core-embed/instagram');
  unregisterBlockType('core-embed/wordpress');
  unregisterBlockType('core-embed/soundcloud');
  unregisterBlockType('core-embed/spotify');
  unregisterBlockType('core-embed/flickr');
  unregisterBlockType('core-embed/vimeo');
  unregisterBlockType('core-embed/animoto');
  unregisterBlockType('core-embed/cloudup');
  unregisterBlockType('core-embed/collegehumor');
  unregisterBlockType('core-embed/crowdsignal');
  unregisterBlockType('core-embed/dailymotion');
  unregisterBlockType('core-embed/hulu');
  unregisterBlockType('core-embed/imgur');
  unregisterBlockType('core-embed/issuu');
  unregisterBlockType('core-embed/kickstarter');
  unregisterBlockType('core-embed/meetup-com');
  unregisterBlockType('core-embed/mixcloud');
  unregisterBlockType('core-embed/polldaddy');
  unregisterBlockType('core-embed/reddit');
  unregisterBlockType('core-embed/reverbnation');
  unregisterBlockType('core-embed/screencast');
  unregisterBlockType('core-embed/scribd');
  unregisterBlockType('core-embed/slideshare');
  unregisterBlockType('core-embed/smugmug');
  unregisterBlockType('core-embed/speaker');
  unregisterBlockType('core-embed/speaker-deck');
  unregisterBlockType('core-embed/tiktok');
  unregisterBlockType('core-embed/ted');
  unregisterBlockType('core-embed/tumblr');
  unregisterBlockType('core-embed/videopress');
  unregisterBlockType('core-embed/wordpress-tv');
  unregisterBlockType('core-embed/amazon-kindle');
  // ...embed.common,
  // ...embed.others,
  unregisterBlockType('core/file');
  unregisterBlockType('core/media-text');
  unregisterBlockType('core/latest-comments');
  unregisterBlockType('core/latest-posts');
  unregisterBlockType('core/more');
  unregisterBlockType('core/nextpage');
  unregisterBlockType('core/preformatted');
  unregisterBlockType('core/pullquote');
  unregisterBlockType('core/rss');
  unregisterBlockType('core/search');
  // unregisterBlockType('core/reusable-block'); // ?
  // unregisterBlockType('core/reusable'); // ?
  unregisterBlockType('core/social-links');
  unregisterBlockType('core/social-link');
  unregisterBlockType('core/spacer');
  unregisterBlockType('core/subhead');
  unregisterBlockType('core/tag-cloud');
  unregisterBlockType('core/text-columns');
  unregisterBlockType('core/verse');
  unregisterBlockType('core/video');

  // Unregister WP block styles
  unregisterBlockStyle('core/separator', 'wide');
  unregisterBlockStyle('core/button', 'fill');
  unregisterBlockStyle('core/button', 'outline');
  unregisterBlockStyle('core/image', 'default');
  unregisterBlockStyle('core/image', 'rounded');
  unregisterBlockStyle('core/table', 'regular');
  unregisterBlockStyle('core/table', 'stripes');

  // Unregister WP block variations
  unregisterBlockVariation('core/columns', 'two-columns-one-third-two-thirds');
  unregisterBlockVariation('core/columns', 'two-columns-two-thirds-one-third');
  unregisterBlockVariation('core/columns', 'three-columns-wider-center');

  // Register custom blocks
  registerBlockType(accordion.name, accordion.settings);
  registerBlockType(callout.name, callout.settings);
  registerBlockType(card.name, card.settings);
  registerBlockType(recentPosts.name, recentPosts.settings);
  registerBlockType(contactForm.name, contactForm.settings);

  registerBlockType(cover.name, cover.settings);
  registerBlockType(coverButton.name, coverButton.settings);
  registerBlockType(review.name, review.settings);
  registerBlockType(featured_program.name, featured_program.settings);
  registerBlockType(book_now.name, book_now.settings);
  registerBlockType(sponsors.name, sponsors.settings);
  registerBlockType(parkLayout.name, parkLayout.settings);

  // Register custom block styles
  registerBlockStyle( 'core/button', {
    name: 'primary',
    label: 'Primary',
    isDefault: true
  } );
  registerBlockStyle( 'core/button', {
    name: 'secondary',
    label: 'Secondary'
  } );
  registerBlockStyle( 'core/table', {
    name: 'striped',
    label: 'Striped',
    isDefault: true
  } );
  registerBlockStyle( 'core/table', {
    name: 'unstriped',
    label: 'Unstriped'
  } );
  registerBlockStyle( 'core/image', {
    name: 'default',
    label: 'Default',
    isDefault: true
  } );
  registerBlockStyle( 'core/image', {
    name: 'padded',
    label: 'Padded'
  } );
  registerBlockStyle( 'core/group', {
    name: 'padded',
    label: 'Padded'
  } );
  registerBlockStyle( 'core/columns', {
    name: 'no-stack',
    label: 'No Stacking'
  } );
};
