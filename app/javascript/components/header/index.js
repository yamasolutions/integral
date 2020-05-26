import React from 'react'
import ReactDOM from 'react-dom'

/**
 * WordPress dependencies
 */
import { __ } from '@wordpress/i18n';
import {
	//TableOfContents,
	EditorHistoryRedo,
	EditorHistoryUndo,
} from '@wordpress/editor';

import {
	// BlockToolbar,
	NavigableToolbar,
	// BlockNavigationDropdown,
	// ToolSelector,
} from '@wordpress/block-editor';

export default function Header() {
	return (
		<div
			className="getdavesbe-header"
			role="region"
			aria-label={ __( 'Standalone Editor top bar.', 'getdavesbe' ) }
			tabIndex="-1"
		>
			<h1 className="getdavesbe-header__title">
				{ __( 'Standalone Block Editor', 'getdavesbe' ) }
			</h1>
      <NavigableToolbar
        className="edit-post-header-toolbar"
      >
        <EditorHistoryUndo />
        <EditorHistoryRedo />
      </NavigableToolbar>
		</div>
	);
}
