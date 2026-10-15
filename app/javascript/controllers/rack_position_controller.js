import { Controller } from "@hotwired/stimulus"

// Shows which units an equipment occupies, given its top U and its modele height.
export default class extends Controller {
  static targets = ["modele", "position", "hint"]

  static values = {
    heights: Object,
    hint: String,
    emptyHint: String,
  }

  connect() {
    this.refresh()
  }

  refresh() {
    const position = parseInt(this.positionTarget.value, 10)

    if (Number.isNaN(position)) {
      this.hintTarget.textContent = this.emptyHintValue
      return
    }

    const height = Math.max(parseInt(this.heightsValue[this.modeleTarget.value], 10) || 1, 1)
    const units = height === 1 ? `U${position}` : `U${position - height + 1}-${position}`

    this.hintTarget.textContent = this.hintValue.replace("%{units}", units)
  }
}
