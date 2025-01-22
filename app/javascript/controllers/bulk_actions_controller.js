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

  async submit(e) {
    e.preventDefault()

    if (typeof e.params.confirm === "string") {
      if (!await this.confirm(e.params.confirm)) {
        return
      }
    }

    const method = e.params.method || "post"
    const url = e.params.url
    let data = new FormData()
    this.checked.forEach(checkbox => data.append("ids[]", checkbox.value))

    const request = new FetchRequest(method, url, {
      query: data,
      responseKind: "turbo-stream",
    })

    this.showProgressBar()
    const response = await request.perform()

    if (response.redirected && !response.isTurboStream) {
      Turbo.visit(response.response.url, {
        action: "replace",
        response: {
          statusCode: 200,
          responseHTML: await response.text,
          redirected: true,
        },
      })
    }
    this.hideProgressBar()
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

  async confirm(message) {
    return Promise.resolve(confirm(message))
  }

  showProgressBar() {
    Turbo.navigator.delegate.adapter.progressBar.setValue(0)
    Turbo.navigator.delegate.adapter.progressBar.show()
  }

  hideProgressBar() {
    Turbo.navigator.delegate.adapter.progressBar.setValue(1)
    Turbo.navigator.delegate.adapter.progressBar.hide()
  }

  get checked() {
    return this.checkboxTargets.filter((checkbox) => checkbox.checked)
  }

  get unchecked() {
    return this.checkboxTargets.filter((checkbox) => !checkbox.checked)
  }
}
