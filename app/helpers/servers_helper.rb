module ServersHelper
  def calculate_ports_sums(frame, servers)
    # sums per frame and per type of port
    sums = { frame.id => {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0} }

    servers.each do |server|
      server.ports_per_type.each do |type, sum|
        sums[frame.id][type] = sums[frame.id][type].to_i + sum
      end
    end

    sums
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, card_id:, selected_port:, moved_connections: [])
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect {|p| p.position == index+1}
      port_id = port_data.try(:id)

      # Add moved connections if any
      if port_data.present? && moved_connections.present?
        connection = moved_connections.select{|c| c.port_from_id == port_id || c.port_to_id == port_id}.first
        port_data = connection if connection.present?
      end

      html += content_tag( :span,
                           link_to_port(index+1, port_data, port_type, card_id, port_id),
                           class: "port_container #{selected_port.present? && port_id == selected_port.try(:id) ? "selected" : ""}")
    end
    html.html_safe
  end

  def link_to_port(position, port_data, port_type, card_id, port_id)
    case port_type.name
      when 'RJ'
        link_to_port_by_type(port_data.present? ? port_data.cablename : '', "RJ", port_data, position, card_id, port_id)
      when 'XRJ'
        link_to_port_by_type(port_data.present? ? port_data.cablename : '', "RJ", port_data, position, card_id, port_id)
      when 'FC'
        link_to_port_by_type(port_data.present? ? port_data.cablename : '', "FC", port_data, position, card_id, port_id)
      else
        link_to_port_by_type("#{port_type.try(:name)}<BR>#{port_data.try(:cablename)}".html_safe, port_type.name, port_data, position, card_id, port_id)
    end
  end

  def link_to_port_by_type(label, type, port_data, position, card_id, port_id)
    edit_port_url = port_id ? connections_edit_path(from_port_id: port_id) : edit_port_path(id: 0, card_id: card_id, position: position)
    if ['RJ', 'XRJ', 'FC'].include? type
      port_class = type
    else
      port_class = "SCSI"
    end
    link_to label,
        edit_port_url,
        {class: "port pull-left port#{port_class} #{port_data.try(:cablecolor)}",
        id: port_id,
        data: {url: edit_port_url,
               position: position,
               type: type,
               toggle: 'tooltip',
               placement: 'top',
               title: port_data.present? ? "#{port_data.vlans}" : ""}
    }
  end

end
