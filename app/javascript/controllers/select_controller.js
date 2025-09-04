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
      hidePlaceholder: true,
      maxOptions: null,
      plugins: this.plugins(),
      searchField: ['text', 'groupName'],
      lockOptgroupOrder: true,
      onInitialize: function() {
        Object.keys(this.options).forEach((key) => {
          if (this.options[key].optgroup !== undefined) {
            this.updateOption(this.options[key].value, {
              ...this.options[key],
              groupName: this.optgroups[this.options[key].optgroup].label
            })
          }
        })
      }
    }
  }

  isMultiple() {
    return this.element.attributes["multiple"] !== undefined
  }
}
