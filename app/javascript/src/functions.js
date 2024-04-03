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
}

var loadPaletteColorPicker = function(selector){
    let colors = []
    for(let color_key in colors_hash){
        let tmp_hash = {}
        tmp_hash[color_key] = colors_hash[color_key]
        colors.push(tmp_hash)
    }
    $(selector).paletteColorPicker({
        colors: colors,
        timeout: 2000,
        position: 'upside'
    })
}

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
        return true
    }else{
        return false
    }
}

function each_exists(array){
    for(let index in array){
        if(exists(array[index])==false){
            return false
        }
    }
    return true
}

function log(string, object = undefined){
    let print = ""
    if(object){
        print = string + " : " + JSON.stringify(object)
    }else{
        print = string
    }
    console.log(print)
    return print
}

function rewriteURL(path, params){
    var searchParams = new URLSearchParams(window.location.search)
    for (var key of Object.keys(params)) {
        searchParams.set(key, params[key])
    }
    window.history.replaceState({}, '', path + '?' + searchParams)
}

function uniq(a) {
    return Array.from(new Set(a))
}

function compact(array){
    return array.filter(function(obj) { return obj })
}

function ids_of(array_of_elements){
    return compact(array_of_elements).map(function(elt) {return elt.id})
}
