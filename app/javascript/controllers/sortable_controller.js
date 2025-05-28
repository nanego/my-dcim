import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class SortableController extends Controller {
  static targets = ["container"]

  connect() {
    this.sortable = Sortable.create(this.containerTarget, {
      animation: 150,
      onEnd: this.reorder.bind(this),
      handle: ".ui-sortable-handle"
    })
  }

  reorder() {
    this.containerTarget.querySelectorAll("[data-sortable-item]").forEach((item, index) => {
      const positionField = item.querySelector("[data-sortable-field]")
      positionField.value = index + 1
    })
  }
}
