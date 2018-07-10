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
    "G": "#AAAAAA",
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
            {"G": "#AAAAAA"},
            {"W": "#FFFFFF"}
        ],
        timeout: 2000,
        position: 'upside'
    });
};

function findByAttribute(array, attr, value) {
    if(array != undefined){

        if(Array.isArray(array)){
            for(var i = 0; i < array.length; i += 1) {
                if(array[i][attr] === value) {
                    return i;
                }
            }
        }else{
            for (var key of Object.keys(array)) {

                if(array[key][attr] === value) {

                    return key;
                }
            }
        }


    }else{
        return undefined;
    }
}

function exists(value){
    if( value != undefined && (value > 0 || value.length > 0 || typeof value === "boolean" || typeof value === "object") ){
        return true;
    }else{
        return false;
    }
}
