import { Controller } from "stimulus"

export default class extends Controller {
  openModal(event) {
    const modal = document.getElementById(this.element.dataset.buttonEditCategory)

    if (modal) {
      bootstrap.Modal.getInstance(modal).open()
    } else {
      fetch(this.element.dataset.modalUrl).then((response) => response.json())
        .then((data) => {
          document.querySelector('body').insertAdjacentHTML('beforeend', data.content)
          new bootstrap.Modal(document.getElementById(this.element.dataset.buttonEditCategory)).show()
          // modal.find('form').enableClientSideValidations();
          //SlugGenerator.check_for_slugs();
        }).catch(function (error) {
          console.error(error);
        })
    }
  }
}
