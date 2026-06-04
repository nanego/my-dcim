import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "quickSearchInput"]

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
    this.quickSearchInputTarget.value = "false"
    this.element.dataset.turboFrame = "_top"
    this.element.requestSubmit()
  }

  #lastDebounceKey
  useDebounce(duration, callback) {
    if (this.#lastDebounceKey) clearTimeout(this.#lastDebounceKey)
    this.#lastDebounceKey = setTimeout(callback, duration)
  }
}
