$(document).ready(function() {
  var drag_n_drop_activated, update_u_scale, update_warning_messages;

  // See usage in http://localhost:3000/bays/YOUR_BAY_ID
  drag_n_drop_activated = false;
  $('body').on("click", '#drag-n-drop-switcher', function() {
    var source_connected_list, source_frame;
    if (drag_n_drop_activated) {
      drag_n_drop_activated = false;
      $('#drag-n-drop-switcher').html("<span class='bi bi-arrows-move' aria-hidden='true'></span> Activer le drag'n drop");
      $('.frames').sortable('destroy');
      return $('.servers').sortable('destroy');
    } else {
      drag_n_drop_activated = true;
      $('#drag-n-drop-switcher').html("<span class='bi bi-arrows-move' aria-hidden='true'></span> Le drag'n drop est activé !");
      $('.frames').sortable({
        update: function(event, ui) {
          return $.post($(this).data('update-url'), $(this).sortable('serialize'));
        }
      });
      source_connected_list = source_frame = void 0;
      return $('.servers').sortable({
        connectWith: ".connectedFrames",
        start: function(event, ui) {
          source_connected_list = ui.item.parent();
          return source_frame = ui.item.closest('.frame');
        },
        stop: function(event, ui) {
          if (source_connected_list) {
            update_u_scale(source_connected_list);
          }
          update_u_scale(ui.item.parent());
          if (source_frame) {
            update_warning_messages(source_frame);
          }
          return update_warning_messages(ui.item.closest('.frame'));
        },
        update: function() {
          var count, positions;
          count = $(this).find('span.u_scale').length;
          $(this).find('span.u_scale').map(function() {
            $(this).html("" + count);
            return count = count - 1;
          });
          positions = [];
          $(this).find('li.server').map(function() {
            if ($(this).attr("id") !== void 0 && $(this).find('span.u_scale')[0] !== void 0) {
              return positions.push($(this).find('span.u_scale')[0].textContent);
            }
          });
          return $.post($(this).data('update-url'), $(this).sortable('serialize') + '&room=' + $(this).data('room') + '&islet=' + $(this).data('islet') + '&frame=' + $(this).data('frame') + '&positions=' + positions);
        }
      });
    }
  });

  update_u_scale = function(list) {
    var count;
    count = list.find('span.u_scale').length;
    return list.find('span.u_scale').map(function() {
      $(this).html("" + count);
      if (count % 2 === 0) {
        $(this).removeClass('odd').addClass('even');
      } else {
        $(this).removeClass('even').addClass('odd');
      }
      return count = count - 1;
    });
  };

  update_warning_messages = function(frame) {
    var max_fc, max_rj45, max_u, total_fc, total_rj45, total_u;
    max_u = frame.closest('.frames').data('max-u');
    max_rj45 = frame.closest('.frames').data('max-rj45');
    max_fc = frame.closest('.frames').data('max-fc');
    total_u = total_rj45 = total_fc = 0;
    frame.find('.servers li.server').each(function() {
      if ($(this).data('u')) {
        total_u += $(this).data('u');
      }
      if ($(this).data('rj45-futur')) {
        total_rj45 += $(this).data('rj45-futur');
      }
      if ($(this).data('fc-futur')) {
        return total_fc += $(this).data('fc-futur');
      }
    });
    frame.find('.card-footer .label').each(function() {
      return $(this).removeClass('label-danger');
    });
    frame.find('.card-footer .u').html("Σ U : " + total_u);
    frame.find('.card-footer .rj45').html("Σ RJ45 : " + total_rj45);
    return frame.find('.card-footer .fc').html("Σ FC : " + total_fc);
  };

  // Nested forms see exp http://localhost:3000/servers/YOUR_SERVER_ID/edit
  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').addClass("d-none");
    return event.preventDefault();
  });

  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });

  return $('.server').hover((function() {
    return $(this).addClass('hover');
  }), function() {
    return $(this).removeClass('hover');
  });
});
