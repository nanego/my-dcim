import { Controller } from "@hotwired/stimulus"
import "form-request-submit-polyfill"

export default class extends Controller {
  initialize() {
    this.onRender = this.onRender.bind(this)
  }

  connect() {
    window.addEventListener("turbo:before-stream-render", this.onRender)
  }

  disconnect() {
    window.removeEventListener("turbo:before-stream-render", this.onRender)
  }

  update() {
    if (this.element.submit) {
      // Push down in the event loop
      setTimeout(() => {
        this.element.requestSubmit()
      }, 0)
    }
  }

  onRender() {
    this.element.querySelectorAll("[type=submit]").forEach((node) => {
      node.disabled = false
    })
  }
}
