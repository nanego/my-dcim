import ExportPdfController from "controllers/export_pdf_controller"

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
  static targets = ["buttonIcon"]
  static values = {
    hasButtonIcon: Boolean,
    movesProjectId: String,
    movesProjectStepId: String,
  }

  async export(event) {
    this.showSpinner()
    if (this.hasButtonIconValue) this.hideButtonIcon()

    let { filename, urls } = event.params
    urls = urls.split(";");

    const pdfDoc = await this.generatePDF(urls)
    const pdfBytes = await pdfDoc.save()
    const blob = new Blob([pdfBytes], { type: "application/pdf" })

    saveAs(blob, `${filename}.pdf`)

    this.hideSpinner()
    if (this.hasButtonIconValue) this.showButtonIcon()
  }

  async generatePDF(urls) {
    const pdfDoc = await PDFDocument.create();

    for (const url of urls) {
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
