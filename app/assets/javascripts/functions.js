var colors_hash = {"N": "#000000",
    "M": "#8b4c39",
    "R": "#ee3b3b",
    "O": "#FF9000",
    "J": "#FFDD00",
    "V": "#008000",
    "T": "#3B9C9C",
    "B": "#4876ff",
    "Vi": "#663399",
    "P": "#ff9ee5",
    "G": "#DDDDDD",
    "W": "#FFFFFF"
};

var loadPaletteColorPicker = function(selector){
    $(selector).paletteColorPicker({
        colors: [
            {"N": "#000000"},
            {"M": "#8b4c39"},
            {"R": "#ee3b3b"},
            {"O": "#FF9000"},
            {"J": "#FFDD00"},
            {"V": "#008000"},
            {"T": "#3B9C9C"},
            {"B": "#4876ff"},
            {"Vi": "#663399"},
            {"P": "#ff9ee5"},
            {"G": "#DDDDDD"},
            {"W": "#FFFFFF"}
        ],
        timeout: 2000,
        position: 'upside'
    });
};
