import { Controller } from "@hotwired/stimulus"

export default class SearchResults extends Controller {
  static targets = ["result", "popup"]

  connect() {
    if (this.hasResultTarget) {
      this.resultTarget.focus()
    } else {
      const input = document.querySelector("#search_query");

      input.focus()
      input.setSelectionRange(input.value.length, input.value.length)
    }
  }

  closeForEscape(e) {
    if (e.key === "Escape") this.popupTarget.innerHTML = ""
  }

  closeForOustideClick(e) {
    if (!this.popupTarget.contains(e.target)) this.popupTarget.innerHTML = ""
  }
}
