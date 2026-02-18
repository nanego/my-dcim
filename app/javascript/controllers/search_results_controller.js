import { Controller } from "@hotwired/stimulus"

export default class SearchResults extends Controller {
  static targets = ["results"]

  connect() {
    if (this.hasResultsTarget) {
      this.resultsTarget.focus()
    } else {
      const input = document.querySelector('input[type="search"]');

      input.focus()
      input.setSelectionRange(input.value.length, input.value.length)
    }
  }
}
