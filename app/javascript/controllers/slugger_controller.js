import { Controller } from "stimulus"

export default class extends Controller {
  validate() {
    this.element.value = this.slug(this.element.value)
  }

  slugify() {
    const outputField = document.querySelector(this.element.dataset.slugger)
    if (outputField.value == '') {
      outputField.value = this.slug(this.element.value)
    }
  }

  slug(sluggable) {
    return sluggable.toString().toLowerCase()
    .replace(/\s+/g, '-')                 // Replace spaces with -
    .replace(/[^\u0100-\uFFFF\w\-]/g,'-') // Remove all non-word chars ( fix for UTF-8 chars )
    .replace(/\-\-+/g, '-')               // Replace multiple - with single -
    .replace(/^-+/, '')                   // Trim - from start of text
    .replace(/-+$/, '')
  }
}
