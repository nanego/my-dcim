import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static values = {
    options: Object,
  }

  connect() {
    this.select = new TomSelect(this.element, {
      ...this.defaultOptions,
      ...this.optionsValue,
    })

    console.debug(this.select)
  }

  disconnect() {
    this.select.destroy()
  }

  plugins() {
    const plugins = []

    if (this.isMultiple()) {
      plugins.push("remove_button")
    }

    return plugins
  }

  get defaultOptions() {
    return {
      plugins: this.plugins(),
    }
  }

  isMultiple() {
    return this.element.attributes["multiple"] !== undefined
  }
}
