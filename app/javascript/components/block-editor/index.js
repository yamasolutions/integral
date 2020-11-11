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

import {
	BlockEditorKeyboardShortcuts,
	BlockEditorProvider,
	BlockList,
	BlockInspector,
	WritingFlow,
	ObserveTyping,
  BlockBreadcrumb,
} from '@wordpress/block-editor';

/**
 * Internal dependencies
 */
import Sidebar from 'components/sidebar';
import Header from 'components/header';
import { uploadMedia } from 'utils';

function BlockEditor( { input, settings: _settings } ) {
  const blocks = useSelect((select) => select("block-editor").getBlocks());
  const { updateBlocks } = useDispatch("block-editor");

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


  function handleInput(newBlocks, persist) {
    // console.log('Block Editor - onInput Triggered');
    updateBlocks(newBlocks);
    input.value = serialize(newBlocks);
    $(input).trigger("change");
  }

  function handleChange(newBlocks) {
    // console.log('Block Editor - onChange Triggered');
    updateBlocks(newBlocks, true);
    input.value = serialize(newBlocks);
    $(input).trigger("change");
  }

	return (
		<div className="">
			<BlockEditorProvider
				value={ blocks }
				onInput={ handleInput }
				onChange={ handleChange }
				settings={ settings }
			>

        <Header />
        <BlockBreadcrumb />
				<Sidebar.InspectorFill>
					<BlockInspector />
				</Sidebar.InspectorFill>
	  		<div className="block-editor__inner-wrapper">
					<BlockEditorKeyboardShortcuts />
					<WritingFlow>
						<ObserveTyping>
              <BlockList className="editor-styles-wrapper" />
						</ObserveTyping>
					</WritingFlow>
				</div>
			</BlockEditorProvider>

		</div>
	);
}

export default BlockEditor;

