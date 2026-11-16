import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // don't update position input value if not new record
    if (this.element.dataset.newRecord !== "true") return

    const postionInput = this.positionInput()
    const maxPosition = this.maxPostion()

    postionInput.value = maxPosition + 1
  }

  /**
   * return the current socket input position
   * @returns {HTMLInputElement} the position input
   */
  positionInput() {
    return this.numberInputsOf(this.element)[0]
  }

  /**
   * @returns {number} the max socket position in the current circuit
   */
  maxPostion() {
    const allPositionInputs = this.allPositionInputs()
    return allPositionInputs.reduce(
      (prev, input) => Math.max(prev, Number(input.value)),
      0,
    )
  }

  /**
   * get all position inputs from the current circuit
   * @returns {HTMLInputElement[]} all position inputs
   */
  allPositionInputs() {
    const ul = this.element.closest("ul")
    return this.numberInputsOf(ul)
  }

  /**
   * get position input in the element
   * @param {HTMLElement} element
   * @returns {HTMLInputElement[]}
   */
  numberInputsOf(element) {
    return [...element.querySelectorAll('input[type="number"]')]
  }
}
