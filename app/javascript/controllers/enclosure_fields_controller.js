import SortableController from "controllers/sortable_controller"

export default class EnclosureFields extends SortableController {
  static targets = ["gridArea", "displayRadioButton"]

  connect(){
    super.connect()

    this.sortable.options.filter = ".filtered"
    this.sortable.options.onMove = function (evt) {
      return evt.related.className.indexOf("filtered") === -1;
    }

    // Show grid area on page load
    this.displayRadioButtonTargets.forEach((radio) => {
      if (radio.checked) this.toggleGridTextArea(radio)
    })
  }

  displayValueChange(event) {
    this.toggleGridTextArea(event.target)
  }

  toggleGridTextArea(target) {
    this.gridAreaTarget.hidden = true

    if (target.value == "grid") this.gridAreaTarget.hidden = false
  }
}
