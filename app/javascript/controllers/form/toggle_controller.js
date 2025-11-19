import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle({ params: { targetElement }}) {
    this.element.querySelectorAll(targetElement).forEach((elt) => {
      elt.classList.toggle("d-none")
    })
  }
}
