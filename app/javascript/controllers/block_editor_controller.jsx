import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import { Controller } from "stimulus"

import { render } from '@wordpress/element'

import '../styles.scss'

import Editor from './editor'
import { registerBlocks } from '../blocks'

registerBlocks()

export default class extends Controller {
  static targets = [ "output", "input", "maximize", "minimize" ]

  connect() {
    const settings = {
      imageSizes: false,
      disableCustomFontSizes: true,
      fontSizes: false,
      disableCustomColors: true,
      colors: false,
      disableCustomGradients: true,
      __experimentalDisableDropCap: true,
      __experimentalDisableCustomLineHeight: true
    }

    this.inputTarget.classList.add('hide')
    render( <Editor input={ this.inputTarget } settings={ settings } />, this.outputTarget )
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
