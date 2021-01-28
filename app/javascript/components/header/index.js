import React from 'react'
import ReactDOM from 'react-dom'

/**
 * WordPress dependencies
 */
import HistoryUndo from 'components/header/undo';
import HistoryRedo from 'components/header/redo';

import {
	NavigableToolbar,
} from '@wordpress/block-editor';

export default function Header() {
	return (
		<div
			className="block-editor__header"
			role="region"
			tabIndex="-1"
		>
      <NavigableToolbar
        className="edit-post-header-toolbar"
      >
        <HistoryUndo />
        <HistoryRedo />
      </NavigableToolbar>
		</div>
	);
}
