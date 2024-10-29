import { Controller } from "@hotwired/stimulus"

import { html2pdf } from "html2pdf.js"

const exportOptions = {
  margin: 10,
  image: {
    type: "jpeg",
    quality: 1.0
  },
  enableLinks: false,
  html2canvas:  { scale: 1.5 },
  jsPDF: { format: "legal" }
}

export default class extends Controller {
  static targets = ["spinner"]
  static values = { filename: String }

  async export() {
    this.showSpinner()

    const opt = { ...exportOptions, ...{
      filename: `export_${this.filenameValue}`
    }}

    var element = document.getElementById("export-to-pdf").cloneNode(true)
    element.prepend(document.getElementsByTagName("h1")[0].cloneNode(true))
    await html2pdf().set(opt)
                    .from(element)
                    .save()
                    .finally(() => this.hideSpinner())
  }

  showSpinner() {
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("d-none")
  }
}
