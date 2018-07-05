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
//= require palette-color-picker
//= require functions
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

$(document).ready(function(){
  $('.dropdown-toggle').dropdown();
});

$( document ).on( "click", ".draw_connections_link", function(event) {
    $(event.target).html('<span class="glyphicon glyphicon-option-horizontal" aria-hidden="true"></span>')
});
