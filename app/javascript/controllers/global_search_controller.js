import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

export default class extends Controller {
  static targets = ["input", "button"]
  static values = {
    url: String,
    onSearchPage: Boolean
  }

  #fetchKey

  onFocus() {
    if (!this.onSearchPageValue) {
      window.location.href = this.urlValue
    }
  }

  onBtnClick() {
    const currentQuery = this.inputTarget.value

    if (!this.onSearchPageValue) {
      window.location.href = `${this.urlValue}?search_query=${currentQuery}`
      return
    }

    this.search(this.inputTarget.value)
  }

  onInput() {
    if (!this.onSearchPageValue) return

    // debouce 300ms
    const currentKey = getRandomInt(10000)
    this.#fetchKey = currentKey

    this.startLoading()
    setTimeout(async () => {
      // another key has been pressed
      if (this.#fetchKey != currentKey) return

      // don't accept short queries
      let queryValue = this.inputTarget.value
      if (queryValue.length < 2) { queryValue = "" }

      try {
        await this.search(queryValue)
      } catch (e) {
        console.error(e)
      }

      this.stopLoading()
    }, 300)
  }

  async search(query) {
    const ress = await fetch(`${this.urlValue}?search_query=${query}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })

    const html = await ress.text()
    Turbo.renderStreamMessage(html)

    // update url
    const url = new URL(window.location)
    url.searchParams.set("search_query", query)
    window.history.replaceState({}, "", url)
  }

  startLoading() {
    // skip if already loading
    if (this.buttonTarget.disabled) return

    this.buttonTarget.disabled = true
    this.buttonTarget.innerHTML = `
      <span class="spinner-border spinner-border-sm"></span>
    `
  }

  stopLoading() {
    this.buttonTarget.disabled = false
    this.buttonTarget.innerHTML = `
      <span class="bi bi-search"></span>
    `
  }
}
