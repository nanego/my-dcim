import { Controller } from "@hotwired/stimulus"

export default class CollapseAllController extends Controller {
  static values = {
    elements: String
  }

  connect() {
    this.fillCollapses()
  }

  disconnect() {
    this.collaspes = []
  }

  showAll(_) {
    if (this.collapses = []) {
      this.fillCollapses()
    }

    this.collapses.forEach(elt => elt.show())
  }

  hideAll(_) {
    if (this.collapses = []) {
      this.fillCollapses()
    }

    this.collapses.forEach(elt => elt.hide())
  }

  fillCollapses() {
    let elements = document.getElementsByClassName(this.elementsValue)
    this.collapses = [...elements].map(elt => new bootstrap.Collapse(elt, { toggle: false }))
  }
}
