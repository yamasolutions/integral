/**
 * External dependencies
 */
import {
	compact,
	flatMap,
	forEach,
	get,
	has,
	includes,
	map,
	noop,
	omit,
	some,
	startsWith,
} from 'lodash';

/**
 * WordPress dependencies
 */
import apiFetch from '@wordpress/api-fetch';
import { createBlobURL, revokeBlobURL } from '@wordpress/blob';
import { __, sprintf } from '@wordpress/i18n';

/**
 *	Media Upload is used by audio, image, gallery, video, and file blocks to
 *	handle uploading a media file when a file upload button is activated.
 *
 *	TODO: future enhancement to add an upload indicator.
 *	TODO: Handle file validation
 *
 * @param   {Object}   $0                    Parameters object passed to the function.
 * @param   {?Array}   $0.allowedTypes       Array with the types of media that can be uploaded, if unset all types are allowed.
 * @param   {?Object}  $0.additionalData     Additional data to include in the request.
 * @param   {Array}    $0.filesList          List of files.
 * @param   {?number}  $0.maxUploadFileSize  Maximum upload size in bytes allowed for the site.
 * @param   {Function} $0.onError            Function called when an error happens.
 * @param   {Function} $0.onFileChange       Function called each time a file or a temporary representation of the file is available.
 * @param   {?Object}  $0.wpAllowedMimeTypes List of allowed mime types and file extensions.
 */
export async function uploadMedia( {
	allowedTypes,
	additionalData = {},
	filesList,
	maxUploadFileSize,
	onError = noop,
	onFileChange,
	wpAllowedMimeTypes = null,
} ) {
	// Cast filesList to array
	const files = [ ...filesList ];

	const filesSet = [];
	const setAndUpdateFiles = ( idx, value ) => {
		revokeBlobURL( get( filesSet, [ idx, 'url' ] ) );
		filesSet[ idx ] = value;
		onFileChange( compact( filesSet ) );
	};

	for ( const mediaFile of files ) {
		// Set temporary URL to create placeholder media file, this is replaced
		// with final file from media gallery when upload is `done` below
		filesSet.push( { url: createBlobURL( mediaFile ) } );
		onFileChange( filesSet );
	}

	for ( let idx = 0; idx < files.length; ++idx ) {
		const mediaFile = files[ idx ];
		try {
			const savedMedia = await createMediaFromFile(
				mediaFile,
				additionalData
			);
			// const mediaObject = {
			// 	...omit( savedMedia, [ 'alt_text', 'source_url' ] ),
			// 	alt: savedMedia.alt_text,
			// 	caption: get( savedMedia, [ 'caption', 'raw' ], '' ),
			// 	title: savedMedia.title.raw,
			// 	url: savedMedia.source_url,
			// };
      const mediaObject = { url: savedMedia.image.url };
			setAndUpdateFiles( idx, mediaObject );
		} catch ( error ) {
			// Reset to empty on failure.
			setAndUpdateFiles( idx, null );
			let message;
			if ( has( error, [ 'message' ] ) ) {
				message = get( error, [ 'message' ] );
			} else {
				message = sprintf(
					// translators: %s: file name
					__( 'Error while uploading file %s to the media library.' ),
					mediaFile.name
				);
			}
			onError( {
				code: 'GENERAL',
				message,
				file: mediaFile,
			} );
		}
	}
}

/**
 * @param {File}    file           Media File to Save.
 * @param {?Object} additionalData Additional data to include in the request.
 *
 * @return {Promise} Media Object Promise.
 */
function createMediaFromFile( file, additionalData ) {
	const data = new window.FormData();
	data.append( 'image[file]', file, file.name || file.type.replace( '/', '.' ) );
	data.append( 'image[title]', file.name);
	data.append( 'image[title]', file.name);
	data.append( 'image[remote]', 'true');
	forEach( additionalData, ( value, key ) => data.append( key, value ) );
	return apiFetch( {
		path: '/admin/images',
		body: data,
		method: 'POST',
	} );
}

