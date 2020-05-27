import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { render } from '@wordpress/element'
import { registerCoreBlocks } from '@wordpress/block-library'
import { registerBlockType } from '@wordpress/blocks';
import { registerBlockStyle, unregisterBlockStyle } from '@wordpress/blocks';
import Editor from './editor'
import * as callout from '../blocks/callout';

import '../styles.scss'

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output", "input" ]

  connect() {
    this.inputTarget.classList.add('hide')
    const settings = window.getdaveSbeSettings || {
      imageSizes: [],
      disableCustomFontSizes: true,
      fontSizes: [],
      disableCustomColors: true,
      colors: [],
      disableCustomGradients: true
    }
    registerCoreBlocks();
    registerBlockType(callout.name, callout.settings);
    registerBlockStyle( 'core/button', {
      name: 'hollow',
      label: 'Outline'
    } );
    unregisterBlockStyle('core/button', 'outline');

    render( <Editor input={ this.inputTarget } settings={ settings } />, this.outputTarget )
    console.log('Hello Controller!')
  }
}
