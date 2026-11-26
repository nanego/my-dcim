import { Controller } from "@hotwired/stimulus"

export default class ColorPaletteController extends Controller {
  static values = {
    colors: Object,
  }

  connect() {
    let colors = Object
      .entries(this.colorsValue)
      .map(([key, value]) => ({ [key]: value }))

    $(this.element).paletteColorPicker({
      colors,
      timeout: 2000,
      position: "upside",
    })
  }
}
