import "controllers"

window.Trix = require("trix")
require("@rails/actiontext")
Trix.config.blockAttributes.default.tagName = 'p'
