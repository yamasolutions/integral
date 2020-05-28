import React from 'react'
import ReactDOM from 'react-dom'

/**
 * WordPress dependencies
 */
import { Component } from '@wordpress/element'; // TODO: Probably can get rid of this (?)

class MediaUpload extends Component {
  constructor( {
    allowedTypes,
    gallery = false,
    unstableFeaturedImageFlow = false,
    modalClass,
    multiple = false,
    title =  'Select or Upload Media',
  } ) {
    super( ...arguments );
    this.openModal = this.openModal.bind( this );
    this.onSelect = this.onSelect.bind( this );
  }

  onSelect(data) {
		const { onSelect, multiple = false } = this.props;
		onSelect( { id: data.id, url: data.image });
  }

  openModal() {
    window.RecordSelector.open('Media', { callbackSuccess: this.onSelect });
  }

  render() {
    console.log('Media Upload: Component Rendering..');
    return this.props.render( { open: this.openModal } );
  }
}

export default MediaUpload;
