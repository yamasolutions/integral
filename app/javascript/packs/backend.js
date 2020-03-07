/* eslint no-console:0 */

window.CKEDITOR_BASEPATH = '/packs/ckeditor/'
require('ckeditor4')
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
