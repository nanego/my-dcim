import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
  static targets = ["latest", "status", "label", "bar"]

  static values = {
    syncUrl: String,
    requestUrl: String,
    requestId: Number,
    failedMessage: String,
  }

  connect() {
    if (this.requestIdValue) this.follow(this.requestIdValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  async start(event) {
    event.preventDefault()

    const response = await new FetchRequest("put", this.syncUrlValue, { responseKind: "json" }).perform()
    const data = await response.json

    if (data.request_id) {
      this.follow(data.request_id)
    } else if (data.error) {
      this.statusTarget.classList.remove("d-none")
      this.showFailure(data.error)
    }
  }

  follow(requestId) {
    this.statusTarget.classList.remove("d-none")
    this.latestTarget.classList.add("d-none")

    this.poll(requestId)
  }

  async poll(requestId) {
    const url = this.requestUrlValue.replace("__id__", requestId)
    const response = await new FetchRequest("get", url, { responseKind: "json" }).perform()
    const data = await response.json

    this.barTarget.style.width = `${data.progress}%`

    if (data.status === "completed") {
      Turbo.visit(window.location.href, { action: "replace" })
    } else if (data.status === "failed") {
      this.showFailure(data.error_message)
    } else {
      this.timeout = setTimeout(() => this.poll(requestId), 1000)
    }
  }

  showFailure(reason) {
    this.labelTarget.innerText = [this.failedMessageValue, reason].filter(Boolean).join(" : ")
    this.barTarget.classList.add("bg-danger")
    this.element.classList.replace("alert-primary", "alert-danger")
  }
}
