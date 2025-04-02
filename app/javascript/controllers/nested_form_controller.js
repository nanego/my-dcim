import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "target"]
  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
    childIndexName: { type: String, default: "__NEW_RECORD__" },
  }

  add(e) {
    e.preventDefault()

    this.targetTarget.insertAdjacentHTML("beforebegin", this.templateContent())
  }

  remove(e) {
    e.preventDefault()

    const wrapper = e.target.closest(this.wrapperSelectorValue)

    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.classList.add("d-none")
      wrapper.querySelector("input[name*='_destroy']").value="1"
    }
  }

  templateContent() {
    let regex = new RegExp(this.childIndexNameValue, "g");

    return this.templateTarget.innerHTML.replace(regex, new Date().getTime())
  }
}
