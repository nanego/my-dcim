import ExportPdfController from "./export_pdf_controller.js"

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
  html2canvas:  { windowWidth: 1200, width: 1200, scale: 1.25 },
  jsPDF: { format: "legal" }
}

export default class extends ExportPdfController {
  static values = {
    modelIds: Array,
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
                                     `/visualization/frames/${modelId}/print?view=${viewTarget}${ bgWiring ? "&bg=wiring" : ""}`

      const response = await get(url)

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
}
