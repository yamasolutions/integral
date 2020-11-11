/**
 * WordPress dependencies
 */
import { registerStore } from '@wordpress/data';

/**
 * Internal dependencies
 */
import reducer from './reducer';
import * as selectors from './selectors';
import * as actions from './actions';
import * as resolvers from "./resolvers";
import controls from './controls';

/**
 * Module Constants
 */
const MODULE_KEY = 'block-editor';

const store = registerStore(MODULE_KEY, {
	reducer,
	selectors,
	actions,
	controls,
	resolvers,
});

window.blockEditorStore = store;

export default store;
