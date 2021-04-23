import "styles.scss"
import "controllers"

import BlockEditorMediaUploader from 'utils/integral/block_editor_media_uploader';
window.BlockEditorMediaUploader = BlockEditorMediaUploader

window.Trix = require("trix")
require("@rails/actiontext")
Trix.config.blockAttributes.default.tagName = 'p'
