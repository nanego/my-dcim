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

  close(e) {
    if (e.type === "keydown") {
      this.popupTarget.innerHTML = ""
      return
    }

    if (!this.popupTarget.contains(e.target)) {
      this.popupTarget.innerHTML = ""
    }
  }
}
