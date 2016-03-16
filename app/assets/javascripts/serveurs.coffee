# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('.baie').sortable(
    # axis: 'y'
    # handle: '.handle'
    connectWith: ".connectedBaies"
    stop: (event, ui) ->
      count = ui.item.parent().find('span.u_scale').length
      ui.item.parent().find('span.u_scale').map(->
        $(this).html "#{count}"
        count = count - 1;
      )
    update: ->
      # Take in account last change
      count = $(this).find('span.u_scale').length
      $(this).find('span.u_scale').map(->
        $(this).html "#{count}"
        count = count - 1;
      )
      # Get positions in U
      positions = []
      $(this).find('li.serveur').map(->
        if ($(this).attr("id")!=undefined)
          positions.push($(this).find('span.u_scale')[0].innerText)
      )
      # Update db data
      $.post($(this).data('update-url'), $(this).sortable('serialize') + '&salle=' +  $(this).data('salle') + '&ilot=' +  $(this).data('ilot') + '&baie=' +  $(this).data('baie') + '&positions=' + positions)
  );

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
