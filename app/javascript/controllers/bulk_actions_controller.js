import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class BulkActions extends Controller {
  static targets = ["checkboxAll", "checkedCount", "checkbox", "actionsContainer"]

  static values = {
    disableIndeterminate: {
      type: Boolean,
      default: false,
    },
  }

  initialize() {
    this.toggle = this.toggle.bind(this)
    this.refresh = this.refresh.bind(this)
  }

  checkboxAllTargetConnected(checkbox) {
    checkbox.addEventListener("change", this.toggle)

    this.refresh()
  }

  checkboxTargetConnected(checkbox) {
    checkbox.addEventListener("change", this.refresh)

    this.refresh()
  }

  checkboxAllTargetDisconnected(checkbox) {
    checkbox.removeEventListener("change", this.toggle)

    this.refresh()
  }

  checkboxTargetDisconnected(checkbox) {
    checkbox.removeEventListener("change", this.refresh)

    this.refresh()
  }

  toggle(e) {
    e.preventDefault()

    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = e.target.checked
      this.triggerInputEvent(checkbox)
    })

    this.updateCheckCountLabel(this.checked.length)
  }

  refresh() {
    const checkboxesCount = this.checkboxTargets.length
    const checkboxesCheckedCount = this.checked.length

    if (this.disableIndeterminateValue) {
      this.checkboxAllTarget.checked = checkboxesCheckedCount === checkboxesCount
    } else {
      this.checkboxAllTarget.checked = checkboxesCheckedCount > 0
      this.checkboxAllTarget.indeterminate = checkboxesCheckedCount > 0 && checkboxesCheckedCount < checkboxesCount
    }

    this.updateCheckCountLabel(checkboxesCheckedCount)
  }

  submit(e) {
    e.preventDefault()

    const method = e.target.dataset.method || "post"
    let data = new FormData()
    this.checked.forEach(checkbox => data.append("ids[]", checkbox.value))

    const request = new FetchRequest(method, e.target.dataset.url, {
      query: data,
      responseKind: "turbo-stream",
    })

    request.perform()

    // const response = request.perform()
    // if (response.ok) {
    //   const body = response.text
    //   // Do whatever do you want with the response body
    //   // You also are able to call `response.html` or `response.json`, be aware that if you call `response.json` and the response contentType isn't `application/json` there will be raised an error.
    // }
  }

  triggerInputEvent(checkbox) {
    const event = new Event("input", { bubbles: false, cancelable: true })

    checkbox.dispatchEvent(event)
  }

  updateCheckCountLabel(checkCount) {
    if (checkCount === 0){
      this.actionsContainerTarget.style.visibility = "hidden"
    } else {
      this.checkedCountTarget.innerText = checkCount
      this.actionsContainerTarget.style.visibility = "visible"
    }
  }

  get checked() {
    return this.checkboxTargets.filter((checkbox) => checkbox.checked)
  }

  get unchecked() {
    return this.checkboxTargets.filter((checkbox) => !checkbox.checked)
  }
}
