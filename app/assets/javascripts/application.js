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

function hideFilters() {
    $('.hide-filters').hide();
    $('.show-filters').show();
    $('.panel-body').hide();
}

function showFilters() {
    $('.hide-filters').show();
    $('.show-filters').hide();
    $('.panel-body').show();
}

$(document).ready(function () {
    $('.dropdown-toggle').dropdown();
});

$(document).on("click", ".draw_connections_link", function (event) {
    $(event.target).html('<span class="glyphicon glyphicon-option-horizontal" aria-hidden="true"></span>')
});

$(document).ready(function () {
    (function scale_large_slots(){
        $(".very-specific-design").each(function (index) {
            var $el = $(this);
            var elHeight = $el.outerHeight();
            var elWidth = $el.outerWidth();

            var $wrapper = $el.closest(".scaleable-wrapper");
            // $el.css('width', $wrapper.width());

            $wrapper.resizable({
                resize: doResize
            });

            function doResize(event, ui) {

                if (elWidth > ui.size.width && ui.size.width > 100) {
                    var scale, origin;

                    scale = Math.min(
                        ui.size.width / elWidth,
                        ui.size.height / elHeight
                    );

                    $el.css({
                        transform: "translate(0,0) " + "scale(" + scale + ")"
                    });
                } else {
                    $el.css({
                        transform: "translate(0,0) " + "scale(1)"
                    });
                }

            }

            var starterData = {
                size: {
                    width: $wrapper.width() - 5,
                    height: $wrapper.height()
                }
            }
            doResize(null, starterData);

        });
    })();
    window.addEventListener('resize', function (event) {
        scale_large_slots()
    });
});
