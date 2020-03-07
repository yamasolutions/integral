/*
 * Initializes Ckeditor components example controller works with specially annotated HTML like:
 *
 * <textarea id="unique-id-goes-here" data-controller="ckeditor">
 *
 * Optional data attribute parameters which transform to Ckeditor config options:
 * - customConfig - custom-config
 * - bodyClass - body-class
 * - language - language
 * - toolbar - toolbar
*/
import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const supportedOptions = {
      'ckeditorCustomConfig' : 'customConfig',
      'ckeditorBodyClass' : 'bodyClass',
      'ckeditorLanguage' : 'language',
      'ckeditorToolbar' : 'toolbar'
    }
    const options = {}

    Object.keys(supportedOptions).forEach((attributeKey) => {
      const value = this.element.dataset[attributeKey]

      if (typeof value !== 'undefined') {
        const optionKey = supportedOptions[attributeKey]
        options[optionKey] = value
      }
    })

    CKEDITOR.replace(this.element.id, options)
  }
}
