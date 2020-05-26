import React from 'react'
import ReactDOM from 'react-dom'
/**
 * WordPress dependencies
 */
import '@wordpress/editor'; // This shouldn't be necessary
import '@wordpress/format-library';
import { useSelect, useDispatch } from '@wordpress/data';
import { useEffect, useState, useMemo } from '@wordpress/element';
import { serialize, parse } from '@wordpress/blocks';
import { uploadMedia } from '@wordpress/media-utils';

import {
	BlockEditorKeyboardShortcuts,
	BlockEditorProvider,
	BlockList,
	BlockInspector,
	WritingFlow,
	ObserveTyping,
} from '@wordpress/block-editor';

/**
 * Internal dependencies
 */
import Sidebar from 'components/sidebar';

function BlockEditor( { input, settings: _settings } ) {
	const [ blocks, updateBlocks ] = useState( [] );
	const { createInfoNotice } = useDispatch( 'core/notices' );

	// const canUserCreateMedia = useSelect( ( select ) => {
	// 	const _canUserCreateMedia = select( 'core' ).canUser( 'create', 'media' );
	// 	return _canUserCreateMedia || _canUserCreateMedia !== false;
	// }, [] );
	const canUserCreateMedia = true;

	const settings = useMemo(() => {
		if ( ! canUserCreateMedia ) {
			return _settings;
		}
		return {
			..._settings,
			mediaUpload( { onError, ...rest } ) {
				uploadMedia( {
					wpAllowedMimeTypes: _settings.allowedMimeTypes,
					onError: ( { message } ) => onError( message ),
					...rest,
				} );
			},
		};
	}, [ canUserCreateMedia, _settings ] );

	useEffect( () => {
    console.log(input);
		updateBlocks( () => parse( input.value ) );
		// const storedBlocks = window.localStorage.getItem( 'getdavesbeBlocks' );
    //
		// if ( storedBlocks && storedBlocks.length ) {
		// 	updateBlocks( () => parse( storedBlocks ) );
		// 	createInfoNotice( 'Blocks loaded', {
		// 		type: 'snackbar',
		// 		isDismissible: true,
		// 	} );
		// }
	}, [] );

	function persistBlocks( newBlocks ) {
		updateBlocks( newBlocks );
    input.value = serialize(newBlocks);
		//window.localStorage.setItem( 'getdavesbeBlocks', serialize( newBlocks ) );
	}

	return (
		<div className="getdavesbe-block-editor">
			<BlockEditorProvider
				value={ blocks }
				onInput={ updateBlocks }
				onChange={ persistBlocks }
				settings={ settings }
			>
				<Sidebar.InspectorFill>
					<BlockInspector />
				</Sidebar.InspectorFill>
				<div className="editor-styles-wrapper">
					<BlockEditorKeyboardShortcuts />
					<WritingFlow>
						<ObserveTyping>
							<BlockList className="getdavesbe-block-editor__block-list" />
						</ObserveTyping>
					</WritingFlow>
				</div>
			</BlockEditorProvider>

		</div>
	);
}

export default BlockEditor;

