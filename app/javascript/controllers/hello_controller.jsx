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
import MediaUpload from '../components/media-upload';

import '../styles.scss'

import { Controller } from "stimulus"

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
    registerCoreBlocks();
    registerBlockType(callout.name, callout.settings);
    registerBlockStyle( 'core/button', {
      name: 'hollow',
      label: 'Outline'
    } );
    unregisterBlockStyle('core/button', 'outline');
    unregisterBlockStyle('core/image', 'default');
    unregisterBlockStyle('core/image', 'rounded');

    const replaceMediaUpload = () => MediaUpload;

    addFilter(
      'editor.MediaUpload',
      //'core/edit-post/components/media-upload/replace-media-upload',
      'what-is-this-path-for',
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
