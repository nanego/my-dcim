# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('[data-toggle="tooltip"]').tooltip()

  drag_n_drop_activated = false
  $('body').on "click", '#drag-n-drop-switcher', ->
    if drag_n_drop_activated
      drag_n_drop_activated = false
      $('#drag-n-drop-switcher').html "<span class='glyphicon glyphicon-move' aria-hidden='true'></span> Activer le drag'n drop"
      $('.frames').sortable('destroy')
      $('.servers').sortable('destroy')
    else
      drag_n_drop_activated = true
      $('#drag-n-drop-switcher').html "<span class='glyphicon glyphicon-move' aria-hidden='true'></span> Le drag'n drop est activé !"
      $('.frames').sortable(
        update: (event, ui) ->
          $.post($(this).data('update-url'), $(this).sortable('serialize'))
      );
      source_connected_list = source_frame = undefined
      $('.servers').sortable(
        # axis: 'y'
        # handle: '.handle'
        connectWith: ".connectedFrames"
        start: (event, ui) ->
          source_connected_list = ui.item.parent()
          source_frame = ui.item.closest('.frame')
        stop: (event, ui) ->
          if source_connected_list
            update_u_scale(source_connected_list)
          update_u_scale(ui.item.parent())
          # Update alerts if above limit max
          if source_frame
            update_warning_messages(source_frame)
          update_warning_messages(ui.item.closest('.frame'))
        update: ->
          # Take in account last change
          count = $(this).find('span.u_scale').length
          $(this).find('span.u_scale').map(->
            $(this).html "#{count}"
            count = count - 1;
          )
          # Get positions in U
          positions = []
          $(this).find('li.server').map(->
            if ( $(this).attr("id")!=undefined && $(this).find('span.u_scale')[0]!=undefined )
              positions.push($(this).find('span.u_scale')[0].textContent)
          )
          # Update db data
          $.post($(this).data('update-url'), $(this).sortable('serialize') + '&room=' +  $(this).data('room') + '&islet=' +  $(this).data('islet') + '&frame=' +  $(this).data('frame') + '&positions=' + positions)
      );
  update_u_scale = (list) ->
    count = list.find('span.u_scale').length
    list.find('span.u_scale').map(->
      $(this).html "#{count}"
      if (count % 2 == 0)
        $(this).removeClass('odd').addClass('even')
      else
        $(this).removeClass('even').addClass('odd')
      count = count - 1;
    )
  update_warning_messages = (frame) ->
    max_u = frame.closest('.frames').data('max-u')
    max_rj45 = frame.closest('.frames').data('max-rj45')
    max_fc = frame.closest('.frames').data('max-fc')
    total_u = total_rj45 = total_fc = 0
    frame.find('.servers li.server').each ->
      if $(this).data('u')
        total_u += $(this).data('u')
      if $(this).data('rj45-futur')
        total_rj45 += $(this).data('rj45-futur')
      if $(this).data('fc-futur')
        total_fc += $(this).data('fc-futur')
    frame.find('.panel-footer .label').each ->
      $(this).removeClass('label-danger')
    frame.find('.panel-footer .u').html "Σ U : " + total_u
    frame.find('.panel-footer .rj45').html "Σ RJ45 : " + total_rj45
    frame.find('.panel-footer .fc').html "Σ FC : " + total_fc

  # Nested forms
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.server').hover (->
    $(this).addClass 'hover'
  ), ->
    $(this).removeClass 'hover'

