import { Controller } from "@hotwired/stimulus"

export default class ColorPaletteController extends Controller {
  connect() {
    // color_hash is set in the "window" object
    // TODO: cleanup color_hash
    let colors = Object
      .entries(colors_hash)
      .map(([key, value]) => ({ [key]: value }))

    $(this.element).paletteColorPicker({
        colors,
        timeout: 2000,
        position: 'upside'
    })
  }
}
