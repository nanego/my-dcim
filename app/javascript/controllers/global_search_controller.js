import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

export default class extends Controller {
  static targets = ["searchInput"]
  static values = { onSearchPage: Boolean }

  #fetchKey

  goToSearch() {
    if (!this.onSearchPageValue) {
      this.element.requestSubmit()
    }
  }

  submit() {
    if (!this.onSearchPageValue) return

    // debouce 300ms
    const currentKey = getRandomInt(10000)
    this.#fetchKey = currentKey

    setTimeout(async () => {
      // another input has been modified since
      if (this.#fetchKey != currentKey) return

      // don't accept short queries
      let queryValue = this.searchInputTarget.value
      if (queryValue.length < 2) { queryValue = "" }

      this.element.requestSubmit()
    }, 300)
  }
}
