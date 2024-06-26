import "src/palette-color-picker"
import "src/functions"
import "src/bays"
import "src/servers"

import Sortable from "sortablejs"
window.Sortable = Sortable

function hideFilters() {
    $('.hide-filters').hide()
    $('.show-filters').show()
    $('.card-body').hide()
}
window.hideFilters = hideFilters

function showFilters() {
    $('.hide-filters').show()
    $('.show-filters').hide()
    $('.card-body').show()
}
window.showFilters = showFilters

$(document).on("click", ".draw_connections_link", function (event) {
    $(event.target).html('<span class="bi bi-three-dots" aria-hidden="true"></span>')
})

$(document).ready(function () {
    scale_large_slots()
    window.addEventListener('resize', function (event) {
        scale_large_slots()
    })
})

function scale_large_slots(){
    $(".very-specific-design").each(function (index) {
        var $el = $(this)
        var elHeight = $el.outerHeight()
        var elWidth = $el.outerWidth()

        var $wrapper = $el.closest(".scaleable-wrapper")
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
                )

                $el.css({
                    transform: "translate(" + (elWidth - ui.size.width) / 2 + "px) " + "scale(" + scale + ")"
                })
            } else {
                $el.css({
                    transform: "translate(0,0) " + "scale(1)"
                })
            }

        }

        var starterData = {
            size: {
                width: $wrapper.width() - 5,
                height: $wrapper.height()
            }
        }
        doResize(null, starterData)

    })
}
window.scale_large_slots = scale_large_slots

// UI hack
// Get height of all back U, and set front U accordingly
function reset_u_heights() {
    let heights = {};
    $(".frames .view-back li").each(function (index, value) {
        heights[$(this).data('num-u')] = $(this).height();
        // console.log('li' + index + ':' + $(this).data('num-u') + ' -> ' + $(this).height());
    });
    jQuery.each(heights, function (index, value) {
        $(".frames .view-front li[data-num-u='" + index + "']").height(value + 'px');
    });
}
window.reset_u_heights = reset_u_heights