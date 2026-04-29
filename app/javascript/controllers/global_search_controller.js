import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["searchInput"]
  static values = { onSearchPage: Boolean }

  goToSearch() {
    if (!this.onSearchPageValue) {
      this.element.requestSubmit()
    }
  }

  submit() {
    if (!this.onSearchPageValue) return

    this.useDebounce(300, () => {
      // don't accept short queries
      let queryValue = this.searchInputTarget.value
      if (queryValue.length < 2) { queryValue = "" }

      this.element.requestSubmit()
    })
  }

  #lastDebounceKey
  useDebounce(duration, callback) {
    if (this.#lastDebounceKey) clearTimeout(this.#lastDebounceKey)
    this.#lastDebounceKey = setTimeout(callback, duration)
  }
}
