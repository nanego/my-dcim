import { Controller } from "@hotwired/stimulus"

export default class SearchResults extends Controller {
  static targets = ["result", "popup"]

  connect() {
    if (this.hasPopupTarget) {
      document.addEventListener("keydown", (e) => {
        if (e.key === "Escape") this.popupTarget.innerHTML = ""
      })

      document.addEventListener("click", (e) => {
        if (!this.popupTarget.contains(e.target)) this.popupTarget.innerHTML = ""
      })
    }

    if (this.hasResultTarget) {
      this.resultTarget.focus()
    } else {
      const input = document.querySelector("#search_query");

      input.focus()
      input.setSelectionRange(input.value.length, input.value.length)
    }
  }
}
