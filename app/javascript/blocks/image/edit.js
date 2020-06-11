/**
 * External dependencies
 */
import classnames from 'classnames';
import React from 'react';
import ReactDOM from 'react-dom';
import { get, filter, map, last, omit, pick, includes } from 'lodash';

/**
 * WordPress dependencies
 */
import { getBlobByURL, isBlobURL, revokeBlobURL } from '@wordpress/blob';
import {
	ExternalLink,
	PanelBody,
	ResizableBox,
	Spinner,
	TextareaControl,
	TextControl,
	ToolbarGroup,
	withNotices,
} from '@wordpress/components';
import { useViewportMatch } from '@wordpress/compose';
import { useSelect, useDispatch } from '@wordpress/data';
import {
	BlockAlignmentToolbar,
	BlockControls,
	BlockIcon,
	InspectorControls,
	InspectorAdvancedControls,
	MediaPlaceholder,
	MediaReplaceFlow,
	RichText,
	__experimentalBlock as Block,
	__experimentalImageSizeControl as ImageSizeControl,
	__experimentalImageURLInputUI as ImageURLInputUI,
} from '@wordpress/block-editor';
import { useEffect, useState, useRef } from '@wordpress/element';
import { __, sprintf } from '@wordpress/i18n';
import { getPath } from '@wordpress/url';
import { image as icon } from '@wordpress/icons';
import { createBlock } from '@wordpress/blocks';

/**
 * Internal dependencies
 */
import { calculatePreferedImageSize } from '@wordpress/block-library/src/image/utils';

/**
 * Module constants
 */
import {
	MIN_SIZE,
	LINK_DESTINATION_MEDIA,
	LINK_DESTINATION_ATTACHMENT,
	ALLOWED_MEDIA_TYPES,
	DEFAULT_SIZE_SLUG,
} from '@wordpress/block-library/src/image/constants';

export const pickRelevantMediaFiles = ( image ) => {
	const imageProps = pick( image, [ 'alt', 'id', 'link', 'caption' ] );
	imageProps.url =
		get( image, [ 'sizes', 'large', 'url' ] ) ||
		get( image, [ 'media_details', 'sizes', 'large', 'source_url' ] ) ||
		image.url;
	return imageProps;
};


const useImageSize = ( ref, src, dependencies ) => {
	const [ state, setState ] = useState( {
		imageWidth: null,
		imageHeight: null,
		imageWidthWithinContainer: null,
		imageHeightWithinContainer: null,
	} );

	useEffect( () => {
		if ( ! src ) {
			return;
		}

		const { defaultView } = ref.current.ownerDocument;
		const image = new defaultView.Image();

		function calculateSize() {
			const { width, height } = calculatePreferedImageSize(
				image,
				ref.current
			);

			setState( {
				imageWidth: image.width,
				imageHeight: image.height,
				imageWidthWithinContainer: width,
				imageHeightWithinContainer: height,
			} );
		}

		defaultView.addEventListener( 'resize', calculateSize );
		image.addEventListener( 'load', calculateSize );
		image.src = src;

		return () => {
			defaultView.removeEventListener( 'resize', calculateSize );
			image.removeEventListener( 'load', calculateSize );
		};
	}, [ src, ...dependencies ] );

	return state;
}

/**
 * Is the URL a temporary blob URL? A blob URL is one that is used temporarily
 * while the image is being uploaded and will not have an id yet allocated.
 *
 * @param {number=} id The id of the image.
 * @param {string=} url The url of the image.
 *
 * @return {boolean} Is the URL a Blob URL
 */
const isTemporaryImage = ( id, url ) => ! id && isBlobURL( url );

/**
 * Is the url for the image hosted externally. An externally hosted image has no
 * id and is not a blob url.
 *
 * @param {number=} id  The id of the image.
 * @param {string=} url The url of the image.
 *
 * @return {boolean} Is the url an externally hosted url?
 */
const isExternalImage = ( id, url ) => url && ! id && ! isBlobURL( url );

function getFilename( url ) {
	const path = getPath( url );
	if ( path ) {
		return last( path.split( '/' ) );
	}
}

export function ImageEdit( {
	attributes: {
		url = '',
		alt,
		caption,
		align,
		id,
		href,
		rel,
		linkClass,
		linkDestination,
		title,
		width,
		height,
		linkTarget,
		sizeSlug,
	},
	setAttributes,
	isSelected,
	className,
	noticeUI,
	insertBlocksAfter,
	noticeOperations,
	onReplace,
} ) {
	const ref = useRef();
	const { image, maxWidth, isRTL, imageSizes, mediaUpload } = useSelect(
		( select ) => {
			const { getMedia } = select( 'core' );
			const { getSettings } = select( 'core/block-editor' );
			return {
				...pick( getSettings(), [
					'mediaUpload',
					'imageSizes',
					'isRTL',
					'maxWidth',
				] ),
				image: id && isSelected ? getMedia( id ) : null,
			};
		},
		[ id, isSelected ]
	);
	const { toggleSelection } = useDispatch( 'core/block-editor' );
	const isLargeViewport = useViewportMatch( 'medium' );
	const [ captionFocused, setCaptionFocused ] = useState( false );
	const isWideAligned = includes( [ 'wide', 'full' ], align );

	function onResizeStart() {
		toggleSelection( false );
	}

	function onResizeStop() {
		toggleSelection( true );
	}

	function onUploadError( message ) {
		noticeOperations.removeAllNotices();
		noticeOperations.createErrorNotice( message );
	}

	function onSelectImage( media ) {
		if ( ! media || ! media.url ) {
			setAttributes( {
				url: undefined,
				alt: undefined,
				id: undefined,
				title: undefined,
				caption: undefined,
			} );
			return;
		}

		let mediaAttributes = pickRelevantMediaFiles( media );

		// If the current image is temporary but an alt text was meanwhile
		// written by the user, make sure the text is not overwritten.
		if ( isTemporaryImage( id, url ) ) {
			if ( alt ) {
				mediaAttributes = omit( mediaAttributes, [ 'alt' ] );
			}
		}

		// If a caption text was meanwhile written by the user,
		// make sure the text is not overwritten by empty captions.
		if ( caption && ! get( mediaAttributes, [ 'caption' ] ) ) {
			mediaAttributes = omit( mediaAttributes, [ 'caption' ] );
		}

		let additionalAttributes;
		// Reset the dimension attributes if changing to a different image.
		if ( ! media.id || media.id !== id ) {
			additionalAttributes = {
				width: undefined,
				height: undefined,
				sizeSlug: DEFAULT_SIZE_SLUG,
			};
		} else {
			// Keep the same url when selecting the same file, so "Image Size"
			// option is not changed.
			additionalAttributes = { url };
		}

		// Check if the image is linked to it's media.
		if ( linkDestination === LINK_DESTINATION_MEDIA ) {
			// Update the media link.
			mediaAttributes.href = media.url;
		}

		// Check if the image is linked to the attachment page.
		if ( linkDestination === LINK_DESTINATION_ATTACHMENT ) {
			// Update the media link.
			mediaAttributes.href = media.link;
		}

		setAttributes( {
			...mediaAttributes,
			...additionalAttributes,
		} );
	}

	function onSelectURL( newURL ) {
		if ( newURL !== url ) {
			setAttributes( {
				url: newURL,
				id: undefined,
				sizeSlug: DEFAULT_SIZE_SLUG,
			} );
		}
	}

	function onImageError() {
    console.log('An image error occurred.')
		// // Check if there's an embed block that handles this URL.
		// const embedBlock = createUpgradedEmbedBlock( { attributes: { url } } );
		// if ( undefined !== embedBlock ) {
		// 	onReplace( embedBlock );
		// }
	}

	function onSetHref( props ) {
		setAttributes( props );
	}

	function onSetTitle( value ) {
		// This is the HTML title attribute, separate from the media object
		// title.
		setAttributes( { title: value } );
	}

	function onFocusCaption() {
		if ( ! captionFocused ) {
			setCaptionFocused( true );
		}
	}

	function onImageClick() {
		if ( captionFocused ) {
			setCaptionFocused( false );
		}
	}

	function updateAlt( newAlt ) {
		setAttributes( { alt: newAlt } );
	}

	function updateAlignment( nextAlign ) {
		const extraUpdatedAttributes = isWideAligned
			? { width: undefined, height: undefined }
			: {};
		setAttributes( {
			...extraUpdatedAttributes,
			align: nextAlign,
		} );
	}

	function updateImage( newSizeSlug ) {
		const newUrl = get( image, [
			'media_details',
			'sizes',
			newSizeSlug,
			'source_url',
		] );
		if ( ! newUrl ) {
			return null;
		}

		setAttributes( {
			url,
			width: undefined,
			height: undefined,
			sizeSlug: newSizeSlug,
		} );
	}

	function getImageSizeOptions() {
		return map(
			filter( imageSizes, ( { slug } ) =>
				get( image, [ 'media_details', 'sizes', slug, 'source_url' ] )
			),
			( { name, slug } ) => ( { value: slug, label: name } )
		);
	}

	const isTemp = isTemporaryImage( id, url );

	// Upload a temporary image on mount.
	useEffect( () => {
		if ( ! isTemp ) {
			return;
		}

		const file = getBlobByURL( url );

		if ( file ) {
			mediaUpload( {
				filesList: [ file ],
				onFileChange: ( [ img ] ) => {
					onSelectImage( img );
				},
				allowedTypes: ALLOWED_MEDIA_TYPES,
				onError: ( message ) => {
					noticeOperations.createErrorNotice( message );
				},
			} );
		}
	}, [] );

	// If an image is temporary, revoke the Blob url when it is uploaded (and is
	// no longer temporary).
	useEffect( () => {
		if ( ! isTemp ) {
			return;
		}

		return () => {
			revokeBlobURL( url );
		};
	}, [ isTemp ] );

	useEffect( () => {
		if ( ! isSelected ) {
			setCaptionFocused( false );
		}
	}, [ isSelected ] );

	const isExternal = isExternalImage( id, url );
	const controls = (
		<BlockControls>
			<BlockAlignmentToolbar
				value={ align }
				onChange={ updateAlignment }
			/>
			{ url && (
				<MediaReplaceFlow
					mediaId={ id }
					mediaURL={ url }
					allowedTypes={ ALLOWED_MEDIA_TYPES }
					accept="image/*"
					onSelect={ onSelectImage }
					onSelectURL={ onSelectURL }
					onError={ onUploadError }
				/>
			) }
			{ url && (
				<ToolbarGroup>
					<ImageURLInputUI
						url={ href || '' }
						onChangeUrl={ onSetHref }
						linkDestination={ linkDestination }
						mediaUrl={ image && image.source_url }
						mediaLink={ image && image.link }
						linkTarget={ linkTarget }
						linkClass={ linkClass }
						rel={ rel }
					/>
				</ToolbarGroup>
			) }
		</BlockControls>
	);
	const src = isExternal ? url : undefined;
	const mediaPreview = !! url && (
		<img
			alt={ __( 'Edit image' ) }
			title={ __( 'Edit image' ) }
			className={ 'edit-image-preview' }
			src={ url }
		/>
	);

	const mediaPlaceholder = (
		<MediaPlaceholder
			icon={ <BlockIcon icon={ icon } /> }
			onSelect={ onSelectImage }
			onSelectURL={ onSelectURL }
			notices={ noticeUI }
			onError={ onUploadError }
			accept="image/*"
			allowedTypes={ ALLOWED_MEDIA_TYPES }
			value={ { id, src } }
			mediaPreview={ mediaPreview }
			disableMediaButtons={ url }
		/>
	);

	const {
		imageWidthWithinContainer,
		imageHeightWithinContainer,
		imageWidth,
		imageHeight,
	} = useImageSize( ref, url, [ align ] );

	if ( ! url ) {
		return (
			<>
				{ controls }
				<Block.div>{ mediaPlaceholder }</Block.div>
			</>
		);
	}

	const classes = classnames( className, {
		'is-transient': isBlobURL( url ),
		'is-resized': !! width || !! height,
		'is-focused': isSelected,
		[ `size-${ sizeSlug }` ]: sizeSlug,
	} );

	const isResizable = false;
	const imageSizeOptions = getImageSizeOptions();

	const inspectorControls = (
		<>
			<InspectorControls>
				<PanelBody title={ __( 'Image settings' ) }>
					<TextareaControl
						label={ __( 'Alt text (alternative text)' ) }
						value={ alt }
						onChange={ updateAlt }
						help={
							<>
								<ExternalLink href="https://www.w3.org/WAI/tutorials/images/decision-tree">
									{ __(
										'Describe the purpose of the image'
									) }
								</ExternalLink>
								{ __(
									'Leave empty if the image is purely decorative.'
								) }
							</>
						}
					/>
				</PanelBody>
			</InspectorControls>
			<InspectorAdvancedControls>
				<TextControl
					label={ __( 'Title attribute' ) }
					value={ title || '' }
					onChange={ onSetTitle }
					help={
						<>
							{ __(
								'Describe the role of this image on the page.'
							) }
							<ExternalLink href="https://www.w3.org/TR/html52/dom.html#the-title-attribute">
								{ __(
									'(Note: many devices and browsers do not display this text.)'
								) }
							</ExternalLink>
						</>
					}
				/>
			</InspectorAdvancedControls>
		</>
	);

	const filename = getFilename( url );
	let defaultedAlt;

	if ( alt ) {
		defaultedAlt = alt;
	} else if ( filename ) {
		defaultedAlt = sprintf(
			/* translators: %s: file name */
			__( 'This image has an empty alt attribute; its file name is %s' ),
			filename
		);
	} else {
		defaultedAlt = __( 'This image has an empty alt attribute' );
	}

	let img = (
		// Disable reason: Image itself is not meant to be interactive, but
		// should direct focus to block.
		/* eslint-disable jsx-a11y/no-noninteractive-element-interactions, jsx-a11y/click-events-have-key-events */
		<>
			{ inspectorControls }
			<img
				src={ url }
				alt={ defaultedAlt }
				onClick={ onImageClick }
				onError={ () => onImageError() }
			/>
			{ isBlobURL( url ) && <Spinner /> }
		</>
		/* eslint-enable jsx-a11y/no-noninteractive-element-interactions, jsx-a11y/click-events-have-key-events */
	);

	if ( ! isResizable || ! imageWidthWithinContainer ) {
		img = <div style={ { width, height } }>{ img }</div>;
	} else {
		const currentWidth = width || imageWidthWithinContainer;
		const currentHeight = height || imageHeightWithinContainer;

		const ratio = imageWidth / imageHeight;
		const minWidth = imageWidth < imageHeight ? MIN_SIZE : MIN_SIZE * ratio;
		const minHeight =
			imageHeight < imageWidth ? MIN_SIZE : MIN_SIZE / ratio;

		// With the current implementation of ResizableBox, an image needs an
		// explicit pixel value for the max-width. In absence of being able to
		// set the content-width, this max-width is currently dictated by the
		// vanilla editor style. The following variable adds a buffer to this
		// vanilla style, so 3rd party themes have some wiggleroom. This does,
		// in most cases, allow you to scale the image beyond the width of the
		// main column, though not infinitely.
		// @todo It would be good to revisit this once a content-width variable
		// becomes available.
		const maxWidthBuffer = maxWidth * 2.5;

		let showRightHandle = false;
		let showLeftHandle = false;

		/* eslint-disable no-lonely-if */
		// See https://github.com/WordPress/gutenberg/issues/7584.
		if ( align === 'center' ) {
			// When the image is centered, show both handles.
			showRightHandle = true;
			showLeftHandle = true;
		} else if ( isRTL ) {
			// In RTL mode the image is on the right by default.
			// Show the right handle and hide the left handle only when it is
			// aligned left. Otherwise always show the left handle.
			if ( align === 'left' ) {
				showRightHandle = true;
			} else {
				showLeftHandle = true;
			}
		} else {
			// Show the left handle and hide the right handle only when the
			// image is aligned right. Otherwise always show the right handle.
			if ( align === 'right' ) {
				showLeftHandle = true;
			} else {
				showRightHandle = true;
			}
		}
		/* eslint-enable no-lonely-if */

		img = (
			<ResizableBox
				size={ { width, height } }
				showHandle={ isSelected }
				minWidth={ minWidth }
				maxWidth={ maxWidthBuffer }
				minHeight={ minHeight }
				maxHeight={ maxWidthBuffer / ratio }
				lockAspectRatio
				enable={ {
					top: false,
					right: showRightHandle,
					bottom: true,
					left: showLeftHandle,
				} }
				onResizeStart={ onResizeStart }
				onResizeStop={ ( event, direction, elt, delta ) => {
					onResizeStop();
					setAttributes( {
						width: parseInt( currentWidth + delta.width, 10 ),
						height: parseInt( currentHeight + delta.height, 10 ),
					} );
				} }
			>
				{ img }
			</ResizableBox>
		);
	}

	return (
		<>
			{ controls }
			<Block.figure ref={ ref } className={ classes }>
				{ img }
				{ ( ! RichText.isEmpty( caption ) || isSelected ) && (
					<RichText
						tagName="figcaption"
						placeholder={ __( 'Write caption…' ) }
						value={ caption }
						unstableOnFocus={ onFocusCaption }
						onChange={ ( value ) =>
							setAttributes( { caption: value } )
						}
						isSelected={ captionFocused }
						inlineToolbar
						__unstableOnSplitAtEnd={ () =>
							insertBlocksAfter( createBlock( 'core/paragraph' ) )
						}
					/>
				) }
				{ mediaPlaceholder }
			</Block.figure>
		</>
	);
}

export default withNotices( ImageEdit );
