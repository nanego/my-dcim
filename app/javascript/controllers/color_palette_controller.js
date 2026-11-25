import { Controller } from "@hotwired/stimulus"

export default class ColorPaletteController extends Controller {
  connect() {
    let colors = []
    for(let color_key in colors_hash){
        let tmp_hash = {}
        tmp_hash[color_key] = colors_hash[color_key]
        colors.push(tmp_hash)
    }

    $(this.element).paletteColorPicker({
        colors: colors,
        timeout: 2000,
        position: 'upside'
    })
  }
}
