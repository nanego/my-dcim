import { Controller } from "@hotwired/stimulus"

import { get } from "@rails/request.js"
import { html2pdf, saveAs, PDFDocument } from "html2pdf.js"

const exportOptions = {
  margin: 10,
  image: {
    type: "jpeg",
    quality: 1.0
  },
  pagebreak: { avoid: ".server" },
  enableLinks: false,
  html2canvas:  { windowWidth: 1200, width: 1200 },
  jsPDF: { format: "legal" }
}

export default class extends Controller {
  static targets = ["spinner"]
  static values = {
    modelIds: Array,
    filename: String,
    isMove: Boolean
  }

  async export(event) {
    const viewTarget = event.target.closest("a").dataset.viewTarget
    if (!viewTarget) return

    const bgWiring = event.target.dataset.bgWiring

    this.showSpinner()

    const pdfDoc = await this.generatePDF(viewTarget, bgWiring)
    const pdfBytes = await pdfDoc.save()
    const blob = new Blob([pdfBytes], { type: "application/pdf" })

    saveAs(blob, `${this.filenameValue}_${viewTarget}${ bgWiring ? "_wiring" : ""}.pdf`)

    this.hideSpinner()
  }

  async generatePDF(viewTarget, bgWiring) {
    const pdfDoc = await PDFDocument.create();

    for (let i = 0; i < this.modelIdsValue.length; i++) {
      const modelId = this.modelIdsValue[i]


      const url = this.isMoveValue ? `moves/print/${modelId}`:
                                     `/frames/${modelId}/print?view=${viewTarget}${ bgWiring ? "&bg=wiring" : ""}`

      const response = await get(url, {
        responseKind: "application/pdf"
      })

      if (response.ok) {
        const html = await response.text

        const framePage = await html2pdf()
          .set(exportOptions)
          .from(html)
          .output("arraybuffer")

        const tmpDoc = await PDFDocument.load(framePage)
        const tmpPage = await pdfDoc.copyPages(tmpDoc, tmpDoc.getPageIndices())

        tmpPage.forEach((page) => pdfDoc.addPage(page))
      }
    }

    return pdfDoc
  }

  showSpinner() {
    this.spinnerTarget.classList.remove("d-none")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("d-none")
  }
}
