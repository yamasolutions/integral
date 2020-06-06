import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import { render } from '@wordpress/element'
import { registerCoreBlocks } from '@wordpress/block-library'
import { registerBlockType } from '@wordpress/blocks';
import { addFilter } from '@wordpress/hooks';
import { registerBlockStyle, unregisterBlockStyle } from '@wordpress/blocks';

import Editor from './editor'
import * as callout from '../blocks/callout';
import * as card from '../blocks/card';
import MediaUpload from '../components/media-upload';

import '../styles.scss'

import { Controller } from "stimulus"

import ButtonEdit from '../blocks/button/edit';
import { assign } from 'lodash';

import { createHigherOrderComponent } from '@wordpress/compose'
import { Fragment } from '@wordpress/element';
import { InspectorControls, RichText, PlainText } from '@wordpress/block-editor'
import { TextControl, PanelBody, ToggleControl, Button } from '@wordpress/components';
import classnames from 'classnames';

export default class extends Controller {
  static targets = [ "output", "input", "maximize", "minimize" ]

  connect() {
    this.inputTarget.classList.add('hide')
    const settings = window.getdaveSbeSettings || {
      imageSizes: [],
      disableCustomFontSizes: true,
      fontSizes: [],
      disableCustomColors: true,
      colors: [],
      disableCustomGradients: true,
      __experimentalDisableDropCap: true,
      __experimentalDisableCustomLineHeight: true
    }

    const replaceButtonBlockEdit = ( settings, name ) => {
      if ( name !== 'core/button' ) {
        return settings;
      }

      return assign( {}, settings, {
        edit: ButtonEdit,
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

    registerCoreBlocks();
    registerBlockType(callout.name, callout.settings);
    registerBlockType(card.name, card.settings);
    registerBlockStyle( 'core/button', {
      name: 'primary',
      label: 'Primary',
      isDefault: true
    } );
    registerBlockStyle( 'core/button', {
      name: 'secondary',
      label: 'Secondary'
    } );
    unregisterBlockStyle('core/button', 'fill');
    unregisterBlockStyle('core/button', 'outline');
    unregisterBlockStyle('core/image', 'default');
    unregisterBlockStyle('core/image', 'rounded');

    const replaceMediaUpload = () => MediaUpload;

    addFilter(
      'editor.MediaUpload',
      'integral/filters/media-upload',
      replaceMediaUpload
    );

    render( <Editor input={ this.inputTarget } settings={ settings } />, this.outputTarget )
    console.log('Hello Controller!')
  }

  maximize() {
    this.maximizeTarget.classList.add('hide')
    this.minimizeTarget.classList.remove('hide')
    this.element.classList.add('block-editor__fullscreen')
  }

  minimize() {
    this.minimizeTarget.classList.add('hide')
    this.maximizeTarget.classList.remove('hide')
    this.element.classList.remove('block-editor__fullscreen')
  }
}
