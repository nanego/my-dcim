# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('.baie').sortable(
    # axis: 'y'
    # handle: '.handle'
    connectWith: ".connectedBaies"
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize')+ '&salle=' +  $(this).data('salle') + '&ilot=' +  $(this).data('ilot') + '&baie=' +  $(this).data('baie'))
  );
