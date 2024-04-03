$(document).ready(function () {
    $(document).on('click', '.frames .couple', function (event) {
        var body = $(this).find('.col-sm-6')[0]
        var footer = $(this).children('.panel-footer').first()[0]
        if (event.target == this || event.target == body || event.target == footer) {
            window.location.href = $(event.target).closest('.couple').data('url')
        }
    })
    $(document).on('mouseenter', '.frames .couple', function (event) {
        $(event.target).addClass('hover')
    })
    $(document).on('mouseleave', '.frames .couple', function (event) {
        $(event.target).removeClass('hover')
    })
    $(document).on('mouseenter', '.frames .couple .frame', function (event) {
        $(event.target).closest('.couple').removeClass('hover')
    })
    $(document).on('mouseleave', '.frames .couple .frame', function (event) {
        $(event.target).closest('.couple').addClass('hover')
    })
});
