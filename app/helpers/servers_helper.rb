module ServersHelper

  MAX_PORTS_PER_LINE = 24

  def slot_label(server, component)
    cards = server.cards.where('composant_id = ?', component.id)
    cards_names = cards.pluck(:name).reject(&:blank?)
    if cards_names.present?
      if cards.first.twin_card_id.present?
        link_to network_frame_path(server.frame, network_frame_id: Card.find(cards.first.twin_card_id).server.frame_id) do
          "<span class='glyphicon glyphicon-open' aria-hidden='true'></span>#{cards_names.join('-')}".html_safe
        end
      else
        cards_names.join('-')
      end
    else
      component.name.present? ? "#{component.name.include?('SL') ? component.name[2] : component.name}" : component.position
    end
  end

  def ports_by_card_with_presentation(card:, selected_port: nil, moved_connections: [], twin_card_used_ports: [])
    card_type = card.card_type
    ports_per_cell = card_type.port_quantity.to_i / (card_type.rows * card_type.columns)

    html = "<table class='card_layout'>"
    card_type.rows.to_i.times do |row_index|
      html += "<tr>"
      card_type.columns.to_i.times do |column_index|
        html += "<td><div style='display: flex;'>"

        ports_per_cell.times do |cell_index|

          position = get_current_position(card.orientation, card_type, cell_index, row_index, column_index, ports_per_cell)
          port_data = card.ports.detect {|p| p.position == position}
          port_id = port_data.try(:id)
          port_data = include_moved_connections(moved_connections, port_data, port_id) # Add moved connections if any

          html += content_tag(:span,
                              link_to_port(position, port_data, card_type.port_type, card.id, port_id, (position - 1 + card.first_port_position).to_s.rjust(2, "0")),
                              class: "port_container
                                      #{twin_card_used_ports && port_data && port_data.cable_name && twin_card_used_ports.exclude?(port_data.position) ? "no_client" : ""}
                              #{twin_card_used_ports && (port_data.blank? || port_data.cable_name.blank?) && twin_card_used_ports.include?(position) ? "unreferenced_client" : ""}
                              #{selected_port.present? && port_id == selected_port.try(:id) ? "selected" : ""}")

          if (cell_index + 1) % number_of_columns_in_cell(card.orientation, ports_per_cell, card_type.max_aligned_ports) == 0 # Every XX ports do
            html += '</div><div style="clear:both;" /><div style="display: flex;">'
          end

        end

        html += "</div></td>"
      end

      html += "</tr>"
    end
    html += "</table>"
    html.html_safe
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, card_id: nil, selected_port: nil, moved_connections: [], twin_card_used_ports: [])
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect {|p| p.position == index + 1}
      port_id = port_data.try(:id)
      port_data = include_moved_connections(moved_connections, port_data, port_id) # Add moved connections if any

      html += content_tag(:span,
                          link_to_port(index + 1, port_data, port_type, card_id, port_id),
                          class: "port_container
                                  #{twin_card_used_ports && port_data && port_data.cable_name && twin_card_used_ports.exclude?(port_data.position) ? "no_client" : ""}
                          #{twin_card_used_ports && (port_data.blank? || port_data.cable_name.blank?) && twin_card_used_ports.include?(index + 1) ? "unreferenced_client" : ""}
                          #{selected_port.present? && port_id == selected_port.try(:id) ? "selected" : ""}")

      if (index + 1) % MAX_PORTS_PER_LINE == 0 # Every XX ports do
        html += '<div style="clear:both;" />'
      end
    end
    html.html_safe
  end

  def link_to_port(position, port_data, port_type, card_id, port_id, default_label = '')
    case port_type.name
    when 'RJ'
      link_to_port_by_type(port_data && port_data.cable_name ? port_data.cable_name : default_label, "RJ", port_data, position, card_id, port_id)
    when 'XRJ'
      link_to_port_by_type(port_data && port_data.cable_name ? port_data.cable_name : default_label, "RJ", port_data, position, card_id, port_id)
    when 'FC', 'SC'
      link_to_port_by_type(port_data && port_data.cable_name ? port_data.cable_name : default_label, "FC", port_data, position, card_id, port_id)
    else
      link_to_port_by_type("#{port_data.try(:cable_name).present? ? port_data.try(:cable_name) : port_type.try(:name)}".html_safe, port_type.name, port_data, position, card_id, port_id)
    end
  end

  def link_to_port_by_type(label, type, port_data, position, card_id, port_id)
    edit_port_url = port_id ? connections_edit_path(from_port_id: port_id) : edit_port_path(id: 0, card_id: card_id, position: position)
    if ['RJ', 'XRJ', 'FC'].include? type
      port_class = type
    else
      port_class = "SCSI"
    end
    link_to label.to_s,
            edit_port_url,
            {class: "port pull-left port#{port_class} #{port_data.try(:cable_color) ? port_data.try(:cable_color) : "empty"}",
             id: port_id,
             data: {url: edit_port_url,
                    position: position,
                    type: type,
                    toggle: 'tooltip',
                    placement: 'top',
                    title: port_data.present? ? "#{port_data.vlans}" : ""}
            }
  end

  private

  def get_current_position(card_orientation, card_type, cell_index, row_index, column_index, ports_per_cell)

    return 0 if ports_per_cell == 0

    max_aligned_ports = (card_type.max_aligned_ports.to_i > 0 ? card_type.max_aligned_ports.to_i : MAX_PORTS_PER_LINE)

    case card_orientation
    when 'dt-lr'
      number_of_columns_in_cell = ports_per_cell.to_i / max_aligned_ports
      column_index_in_cell = cell_index % number_of_columns_in_cell
      line_index_in_cell = cell_index / number_of_columns_in_cell
      number_of_ports_in_previous_columns = column_index_in_cell * max_aligned_ports
      position_in_cell = max_aligned_ports - line_index_in_cell + number_of_ports_in_previous_columns
      position = (row_index * card_type.columns * ports_per_cell) +
          (column_index * ports_per_cell) +
          position_in_cell
    when 'td-lr'
      number_of_columns_in_cell = ports_per_cell.to_i / max_aligned_ports
      column_index_in_cell = cell_index % number_of_columns_in_cell
      line_index_in_cell = cell_index / number_of_columns_in_cell
      number_of_ports_in_previous_columns = column_index_in_cell * max_aligned_ports
      position_in_cell = 1 + line_index_in_cell + number_of_ports_in_previous_columns
      position = (row_index * card_type.columns * ports_per_cell) +
          (column_index * ports_per_cell) +
          position_in_cell
    else #'lr-td'
      position = (row_index * card_type.columns * ports_per_cell) +
          (column_index * ports_per_cell) +
          cell_index + 1
    end
    position
  end

  def number_of_columns_in_cell(orientation, ports_per_cell, max_aligned_ports)
    case orientation
    when 'dt-lr', 'td-lr'
      (ports_per_cell.to_i / max_aligned_ports.to_i).to_i
    else # lr-td
      max_aligned_ports.to_i
    end
  end


  def include_moved_connections(moved_connections, port_data, port_id)
    if port_data.present? && moved_connections.present?
      connection = moved_connections.select {|c| c.port_from_id == port_id || c.port_to_id == port_id}.first
      port_data = connection if connection.present?
    end
    port_data
  end

  def define_background_color(server:, mode: nil)
    if %w(gestionnaire cluster).include?(mode)
      case mode
      when 'gestionnaire'
        parent_type = 'Gestionnaire'
        parent_id = server.gestion.try(:name)
      when 'cluster'
        parent_type = 'Cluster'
        parent_id = server.cluster.try(:name)
      end
      color = Color.where(parent_type: parent_type, parent_id: parent_id).first
      if color.blank? || color.code.blank?
        color = Color.create!(parent_type: parent_type, parent_id: parent_id, code: lighten_color("##{Digest::MD5.hexdigest(parent_id.to_s || 'test')[0..5]}", 0.4))
      end
      bg_color = color.code
    else
      bg_color = server.modele.try(:color) || lighten_color("##{Digest::MD5.hexdigest(server.modele.try(:name) || 'test')[0..5]}", 0.4)
    end
    return bg_color
  end

end
