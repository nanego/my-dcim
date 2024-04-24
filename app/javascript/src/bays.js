import jQuery from "jquery"

jQuery(document).ready(function () {
  jQuery(document).on('click', '.frames .couple', function (event) {
    var body = jQuery(this).find('.col-sm-6')[0]
    var footer = jQuery(this).children('.panel-footer').first()[0]
    if (event.target == this || event.target == body || event.target == footer) {
      window.location.href = jQuery(event.target).closest('.couple').data('url')
    }
  })
  jQuery(document).on('mouseenter', '.frames .couple', function (event) {
    jQuery(event.target).addClass('hover')
  })
  jQuery(document).on('mouseleave', '.frames .couple', function (event) {
    jQuery(event.target).removeClass('hover')
  })
  jQuery(document).on('mouseenter', '.frames .couple .frame', function (event) {
    jQuery(event.target).closest('.couple').removeClass('hover')
  })
  jQuery(document).on('mouseleave', '.frames .couple .frame', function (event) {
    jQuery(event.target).closest('.couple').addClass('hover')
  })
});