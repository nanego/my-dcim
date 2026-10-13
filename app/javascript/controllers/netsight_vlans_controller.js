import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  apply({ params: { value } }) {
    this.inputTarget.value = value
    this.inputTarget.dispatchEvent(new Event("input", { bubbles: true }))
  }
}
