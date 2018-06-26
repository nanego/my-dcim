$(document).ready(function () {
    $(document).on('click', '.frames .couple', function (event) {
        if (event.target == this) {
            window.location.href = $(event.target).closest('.couple').data('url')
        }
    });
});
