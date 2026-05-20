import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput"]

  submit() {
    this.useDebounce(300, () => {
      // don't accept short queries
      if (this.searchInputTarget.value.length >= 2) {
        this.element.requestSubmit()
      }
    })
  }

  navigate(event) {
    event.preventDefault()
    this.element.dataset.turboFrame = "_top"

    this.element.requestSubmit()

    // reset dataset after for when turbo drive is used
    this.element.dataset.turboFrame = "results"
  }

  #lastDebounceKey
  useDebounce(duration, callback) {
    if (this.#lastDebounceKey) clearTimeout(this.#lastDebounceKey)
    this.#lastDebounceKey = setTimeout(callback, duration)
  }
}
