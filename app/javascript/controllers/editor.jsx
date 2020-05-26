import React from 'react'
import ReactDOM from 'react-dom'

/**
 * WordPress dependencies
 */
import {
	Popover,
	SlotFillProvider,
	DropZoneProvider,
} from '@wordpress/components';

import { InterfaceSkeleton as EditorSkeleton } from '@wordpress/interface';
import {
	BlockBreadcrumb,
} from '@wordpress/block-editor';


// /**
//  * Internal dependencies
//  */
import Notices from 'components/notices';
import Header from 'components/header';
import Sidebar from 'components/sidebar';
import BlockEditor from 'components/block-editor';

function Editor( { input, settings } ) {
  return (
    <SlotFillProvider>
    <DropZoneProvider>
    <EditorSkeleton
      header={ <Header /> }
      sidebar={<Sidebar />}
      content={
        <>
        <Notices />
        <BlockEditor input={input} settings={settings} />
        </>
      }
      footer={
        (
          <div className="edit-post-layout__footer">
          <BlockBreadcrumb />
          </div>
        )
      }
    />
    <Popover.Slot />
    </DropZoneProvider>
    </SlotFillProvider>
  );
}

export default Editor;
