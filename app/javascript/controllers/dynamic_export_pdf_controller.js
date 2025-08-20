import ExportPdfController from "controllers/export_pdf_controller"

import { get } from "@rails/request.js"
import { html2pdf, saveAs, PDFDocument } from "html2pdf.js"

/* Seems not to be used `/moves_projects/${this.movesProjectIdValue}/moves_project_steps/${this.movesProjectStepIdValue}/frames/${modelId}/print` */

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
  static targets = ["buttonIcon"]
  static values = {
    filename: String,
    modelIds: Array,
    isMove: Boolean,
    movesProjectId: String,
    movesProjectStepId: String,
  }

  async export(event) {
    this.showSpinner()
    if (this.isMoveValue) this.hideButtonIcon()

    const urls = event.currentTarget.dataset.exportUrls.split(";");

    const pdfDoc = await this.generatePDF(urls)
    const pdfBytes = await pdfDoc.save()
    const blob = new Blob([pdfBytes], { type: "application/pdf" })

    saveAs(blob, `${this.filenameValue}.pdf`)

    //  TODO: Handle this case in frame export
    // saveAs(blob, `${this.filenameValue}_${viewTarget}${ bgWiring ? "_wiring" : ""}.pdf`)

    this.hideSpinner()
    if (this.isMoveValue) this.showButtonIcon()
  }

  async generatePDF(urls) {
    const pdfDoc = await PDFDocument.create();

    for (let i = 0; i < urls.length; i++) {
      const url = urls[i]

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

  showButtonIcon() {
    this.buttonIconTarget.classList.remove("d-none")
  }

  hideButtonIcon() {
    this.buttonIconTarget.classList.add("d-none")
  }
}
