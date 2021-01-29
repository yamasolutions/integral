import React from 'react'
import ReactDOM from 'react-dom'

/**
 * WordPress dependencies
 */
import { Component } from '@wordpress/element';

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

    this.resourceSelector = new ResourceSelector('Select Image..', document.querySelector("meta[name='integral-file-list-url']").getAttribute("content"));
    this.resourceSelector.on('resources-selected', (event) => {
      this.onSelect(event.resources[0]);
    });
  }

  onSelect(data) {
		const { onSelect, multiple = false } = this.props;
		onSelect( { url: data.image });
  }

  openModal() {
    this.resourceSelector.open();
  }

  render() {
    return this.props.render( { open: this.openModal } );
  }
}

export default MediaUpload;
