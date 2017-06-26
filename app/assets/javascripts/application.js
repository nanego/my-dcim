// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .
//= require bootstrap

function hideFilters(){
  $('.hide-filters').hide();
  $('.show-filters').show();
  $('.panel-body').hide();
}
function showFilters(){
  $('.hide-filters').show();
  $('.show-filters').hide();
  $('.panel-body').show();
}

function loadPaletteColorPicker(selector){
    $(selector).paletteColorPicker({
        colors: [
            {"N": "#000000"},
            {"M": "#8b4c39"},
            {"R": "#ee3b3b"},
            {"O": "#FF9000"},
            {"J": "#EEEE00"},
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
}

$(document).ready(function(){
    $('.dropdown-toggle').dropdown();
});
