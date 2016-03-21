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
        if (count % 2 == 0)
          $(this).removeClass('odd').addClass('even')
        else
          $(this).removeClass('even').addClass('odd')
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
        if ( $(this).attr("id")!=undefined && $(this).find('span.u_scale')[0]!=undefined )
          positions.push($(this).find('span.u_scale')[0].innerText)
      )
      # Update db data
      $.post($(this).data('update-url'), $(this).sortable('serialize') + '&salle=' +  $(this).data('salle') + '&ilot=' +  $(this).data('ilot') + '&baie=' +  $(this).data('baie') + '&positions=' + positions)
  );

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

  # Add connection between ports
  port_overview = (port, destination)->
    field_server_id = "<input type='hidden' name='#{destination}[server_id]' value='#{port.parent().data('server-id')}' />"
    # field_card_id = "<input type='hidden' name='#{destination}[card_id]' value='#{port.parent().data('card-id')}' />"
    field_composant_type = "<input type='hidden' name='#{destination}[composant_type]' value='#{port.parent().data('composant-type')}' />"
    field_composant_id = "<input type='hidden' name='#{destination}[composant_id]' value='#{port.parent().data('composant-id')}' />"
    field_port_position = "<input type='hidden' name='#{destination}[port_position]' value='#{port.data('position')}' />"
    "<p>#{field_server_id}#{field_composant_type}#{field_composant_id}#{field_port_position}<i class='port port#{port.data('type')} label-primary'></i><span style='margin-left: 5px;'>#{port.parent().data('server-name')} : #{port.data('type')} #{port.data('position')}</span></p>"
  $('.server_back').on "click", ".port", ->
    console.log("this.data.position = " + $(this).data('position'))
    console.log("this.parent.data.composant = " + $(this).parent().data('composant') + '-' + $(this).parent().data('id'))
    if $('.port_selection').hasClass('in')
      $('.port_selection .to').html port_overview($(this), 'to')
    else
      $('.port_selection').addClass('in');
      $('.port_selection .from').html port_overview($(this), 'from')

  $('.port_selection .cancel_btn').on "click", ->
    $('.port_selection').removeClass('in');
