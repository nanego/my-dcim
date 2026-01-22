# frozen_string_literal: true

module ServersHelper # rubocop:disable Metrics/ModuleLength
  MAX_PORTS_PER_LINE = 24

  def slot_label(server, component)
    cards = server.cards.select do |card|
      card.composant_id == component.id
    end

    cards_names = cards.map(&:name).compact_blank

    if cards_names.present?
      if cards.first.twin_card_id.present?
        link_to network_frame_path(server.frame, network_frame_id: Card.find(cards.first.twin_card_id).server.frame_id) do
          "<span class='bi bi-upload me-1' aria-hidden='true'></span>#{cards_names.join("-")}".html_safe # rubocop:disable Rails/OutputSafety
        end
      else
        cards_names.join("-")
      end
    elsif component.name.present?
      (component.name.include?("SL") ? component.name[2] : component.name).to_s
    else
      component.position
    end
  end

  def ports_by_card_minimal(card:)
    card_type = card.card_type
    ports_per_cell = card_type.port_quantity.to_i / (card_type.rows * card_type.columns)

    html = "<table class='minimal_card_layout'>"
    card_type.rows.to_i.times do |row_index|
      html += "<tr>"
      card_type.columns.to_i.times do |column_index|
        html += "<td><div class='d-flex'>"

        ports_per_cell.times do |cell_index|
          position = get_current_position(card.orientation, card_type, cell_index, row_index, column_index, ports_per_cell)
          port_data = card.ports.detect { |p| p.position == position }
          port_id = port_data.try(:id)

          html += content_tag(:span,
                              link_to_port_without_label(position, port_data, card_type.port_type, card.id, port_id),
                              class: "port_container d-flex align-items-center")

          if ((cell_index + 1) % number_of_columns_in_cell(card.orientation, ports_per_cell, card_type.max_aligned_ports)).zero? # Every XX ports do
            html += '</div><div class="d-flex">'
          end
        end

        html += "</div></td>"
      end

      html += "</tr>"
    end
    html += "</table>"
    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def ports_by_card_with_presentation(card:, selected_port: nil, moved_connections: [], twin_card_used_ports: [])
    card_type = card.card_type
    ports_per_cell = card_type.port_quantity.to_i / (card_type.rows * card_type.columns)

    html = "<table class='card_layout'>"
    card_type.rows.to_i.times do |row_index|
      html += "<tr>"
      card_type.columns.to_i.times do |column_index|
        html += "<td><div class='d-flex'>"

        ports_per_cell.times do |cell_index|
          position = get_current_position(card.orientation, card_type, cell_index, row_index, column_index, ports_per_cell)
          port_data = card.ports.detect { |p| p.position == position }
          port_id = port_data.try(:id)
          port_data = include_moved_connections(moved_connections, port_data, port_id) # Add moved connections if any
          type = card_type.port_type
          is_vertical_card = %w[td-lr dt-lr].include?(card.orientation)

          html_content = link_to_port(
            position, port_data, type, card.id, port_id, (position - 1 + card.first_port_position).to_s.rjust(2, "0"),
          )
          if %w[RJ XRJ].include?(type.to_s) && (2..10).cover?(card_type.port_quantity)
            html_content += content_tag(:small,
                                        position - 1 + card.first_port_position,
                                        class: class_names("ms-1": is_vertical_card))
          end

          html += content_tag(:span,
                              html_content,
                              class: class_names(
                                "port_container d-flex align-items-center",
                                no_client: twin_card_used_ports && port_data && port_data.cable_name && twin_card_used_ports.exclude?(port_data.position),
                                unreferenced_client: twin_card_used_ports && (port_data.blank? || port_data.cable_name.blank?) && twin_card_used_ports.include?(position),
                                selected: selected_port.present? && port_id == selected_port.try(:id),
                                "flex-column": !is_vertical_card,
                              ))

          if ((cell_index + 1) % number_of_columns_in_cell(card.orientation, ports_per_cell, card_type.max_aligned_ports)).zero? # Every XX ports do
            html += '</div><div class="d-flex">'
          end
        end

        html += "</div></td>"
      end

      html += "</tr>"
    end
    html += "</table>"
    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, card_id: nil, selected_port: nil, moved_connections: [], twin_card_used_ports: [])
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect { |p| p.position == index + 1 }
      port_id = port_data.try(:id)
      is_vertical_card = %w[td-lr dt-lr].include?(port_data&.card&.orientation)
      port_data = include_moved_connections(moved_connections, port_data, port_id) # Add moved connections if any

      html_content = link_to_port(index + 1, port_data, port_type, card_id, port_id)

      if %w[RJ XRJ].include?(port_type.to_s) && (2..10).cover?(port_quantity)
        html_content += content_tag(:small,
                                    index + 1,
                                    class: class_names("ms-1": is_vertical_card))
      end

      html += content_tag(:span,
                          html_content,
                          class: class_names(
                            "port_container float-start d-flex align-items-center",
                            no_client: twin_card_used_ports && port_data && port_data.cable_name && twin_card_used_ports.exclude?(port_data.position),
                            unreferenced_client: twin_card_used_ports && (port_data.blank? || port_data.cable_name.blank?) && twin_card_used_ports.include?(index + 1),
                            selected: selected_port.present? && port_id == selected_port.try(:id),
                            "flex-column": !is_vertical_card,
                          ))
    end

    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def link_to_port_without_label(position, port_data, port_type, card_id, port_id)
    port_type_name = case port_type.name
                     when "RJ", "XRJ"
                       "RJ"
                     when "FC", "SC"
                       "FC"
                     else
                       port_type.name
                     end
    link_to_port_by_type("", port_type_name, port_data, position, card_id, port_id)
  end

  def link_to_port(position, port_data, port_type, card_id, port_id, default_label = "")
    cable_name = port_data&.cable_name.presence || default_label

    case port_type.name
    when "RJ", "XRJ"
      port_type_name = "RJ"
    when "FC", "SC"
      port_type_name = "FC"
      cable_name = position.to_s.rjust(2, "0") if cable_name.blank?
    else
      cable_name = (port_data&.cable_name.presence || port_type.try(:name)).to_s.html_safe # rubocop:disable Rails/OutputSafety
      port_type_name = port_type.name
    end

    link_to_port_by_type(cable_name, port_type_name, port_data, position, card_id, port_id)
  end

  def link_to_port_by_type(label, type, port_data, position, card_id, port_id)
    edit_port_url = port_id ? connections_edit_path(from_port_id: port_id) : edit_port_path(id: 0, card_id: card_id, position: position)

    port_class = if %w[RJ XRJ FC ALIM].include? type
                   type
                 else
                   "SCSI"
                 end

    link_to label.to_s,
            edit_port_url,
            id: port_id,
            title: (port_data.present? ? port_data.vlans.to_s : ""),
            class: "border border-secondary port port#{port_class} #{port_data.try(:cable_color) || "empty"}",
            data: { url: edit_port_url, position:, type:, controller: "tooltip", bs_placement: "top" },
            target: :_top
  end

  private

  def get_current_position(card_orientation, card_type, cell_index, row_index, column_index, ports_per_cell)
    return 0 if ports_per_cell.zero?

    max_aligned_ports = (card_type.max_aligned_ports.to_i.positive? ? card_type.max_aligned_ports.to_i : MAX_PORTS_PER_LINE)

    case card_orientation
    when "dt-lr"
      number_of_columns_in_cell = ports_per_cell.to_i / max_aligned_ports
      column_index_in_cell = cell_index % number_of_columns_in_cell
      line_index_in_cell = cell_index / number_of_columns_in_cell
      number_of_ports_in_previous_columns = column_index_in_cell * max_aligned_ports
      position_in_cell = max_aligned_ports - line_index_in_cell + number_of_ports_in_previous_columns
      position = (row_index * card_type.columns * ports_per_cell) +
                 (column_index * ports_per_cell) +
                 position_in_cell
    when "td-lr"
      number_of_columns_in_cell = ports_per_cell.to_i / max_aligned_ports
      column_index_in_cell = cell_index % number_of_columns_in_cell
      line_index_in_cell = cell_index / number_of_columns_in_cell
      number_of_ports_in_previous_columns = column_index_in_cell * max_aligned_ports
      position_in_cell = 1 + line_index_in_cell + number_of_ports_in_previous_columns
      position = (row_index * card_type.columns * ports_per_cell) +
                 (column_index * ports_per_cell) +
                 position_in_cell
    when "rl-td"
      position = max_aligned_ports - ((row_index * card_type.columns * ports_per_cell) +
        (column_index * ports_per_cell) + cell_index)
    else
      # 'lr-td'
      position = (row_index * card_type.columns * ports_per_cell) +
                 (column_index * ports_per_cell) +
                 cell_index + 1
    end
    position
  end

  def number_of_columns_in_cell(orientation, ports_per_cell, max_aligned_ports)
    case orientation
    when "dt-lr", "td-lr"
      (ports_per_cell.to_i / max_aligned_ports.to_i).to_i
    else
      # lr-td, rl-td
      max_aligned_ports.to_i
    end
  end

  def include_moved_connections(moved_connections, port_data, port_id)
    if port_data.present? && moved_connections.present?
      connection = moved_connections.find { |c| c.port_from_id == port_id || c.port_to_id == port_id }
      port_data = connection if connection.present?
    end
    port_data
  end

  def define_background_color(server:, mode: nil)
    if %w[gestion cluster].include?(mode)
      case mode
      when "gestion"
        parent_type = "Gestionnaire"
        parent_id = server.gestion.try(:name)
      when "cluster"
        parent_type = "Cluster"
        parent_id = server.cluster.try(:name)
      end
      color = Color.where(parent_type: parent_type, parent_id: parent_id).first
      if color.blank? || color.code.blank?
        color = Color.create!(parent_type: parent_type, parent_id: parent_id, code: lighten_color("##{Digest::MD5.hexdigest(parent_id.to_s.presence || "test")[0..5]}", 0.4))
      end
      bg_color = color.code
    else
      bg_color = server.modele.try(:color) || lighten_color("##{Digest::MD5.hexdigest(server.modele.try(:name) || "test")[0..5]}", 0.4)
    end
    bg_color
  end
end
