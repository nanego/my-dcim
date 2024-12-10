import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

const sortableOptions = {
  handle: ".handle",
  animation: 150,
  filter: ".fitlered",
  onEnd: function (evt) {
    evt.to.querySelectorAll("li.composant").forEach((item, index) => {
      item.querySelector("input[name*='[position]']").value = index + 1
    });
  },
  onMove: function (evt) {
    return evt.related.className.indexOf("filtered") === -1;
  }
}

export default class extends Controller {
  static targets = ["sortableList", "gridArea", "displayRadioButton"]

  connect() {
    this.sortable = Sortable.create(this.sortableListTarget, sortableOptions)

    // Show grid area on page load
    this.displayRadioButtonTargets.forEach((radio) => {
      if (radio.checked) this.toggleGridTextArea(radio)
    })
  }

  disconnect() {
    this.sortable.destroy()
  }

  displayValueChange(event) {
    this.toggleGridTextArea(event.target)
  }

  toggleGridTextArea(target) {
    this.gridAreaTarget.hidden = true

    if (target.value == "grid") this.gridAreaTarget.hidden = false
  }
}
