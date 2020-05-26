import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { render } from '@wordpress/element'
import { registerCoreBlocks } from '@wordpress/block-library'
import Editor from './editor'

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
    registerCoreBlocks()
    render( <Editor input={ this.inputTarget } settings={ settings } />, this.outputTarget )
    console.log('Hello Controller!')
  }
}
