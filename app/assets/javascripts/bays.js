$(document).ready(function () {
    $(document).on('click', '.frames .couple', function (event) {
        if (event.target == this) {
            window.location.href = $(event.target).closest('.couple').data('url')
        }
    })
    $(document).on('mouseenter', '.frames .couple', function (event) {
        $(event.target).addClass('hover')
    })
    $(document).on('mouseleave', '.frames .couple', function (event) {
        $(event.target).removeClass('hover')
    })
    $(document).on('mouseenter', '.frames .couple .panel-body, .frames .couple .panel-footer', function (event) {
        $(event.target).closest('.couple').removeClass('hover')
    })
    $(document).on('mouseleave', '.frames .couple .panel-body, .frames .couple .panel-footer', function (event) {
        $(event.target).closest('.couple').addClass('hover')
    })

});
