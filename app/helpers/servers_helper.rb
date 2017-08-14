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

  def port_cablename(port_data)
    if port_data.present? && port_data.connection.present? && port_data.connection.cable.present? && port_data.connection.cable.name.present?
      port_data.connection.cable.name
    else
      ""
    end
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, card_id:, selected_port:)
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect {|p| p.position == index+1}
      html += content_tag( :span,
                           link_to_port(index+1, port_data, port_type, card_id),
                           class: "port_container #{selected_port.present? && port_data.try(:id) == selected_port.try(:id) ? "selected" : ""}")
    end
    html.html_safe
  end

  def link_to_port(position, port_data, port_type, card_id)
    case port_type.name
      when 'RJ'
        link_to_port_by_type(port_cablename(port_data), "RJ", port_data, position, card_id)
      when 'XRJ'
        link_to_port_by_type(port_cablename(port_data), "RJ", port_data, position, card_id)
      when 'FC'
        link_to_port_by_type(port_cablename(port_data), "FC", port_data, position, card_id)
      else
        link_to_port_by_type("#{port_type.try(:name)}<BR>#{port_cablename(port_data)}".html_safe, port_type.name, port_data, position, card_id)
    end
  end

  def link_to_port_by_type(label, type, port_data, position, card_id)
    edit_port_url = port_data.try(:id) ? connections_edit_path(from_port_id: port_data.id) : edit_port_path(id: 0, card_id: card_id, position: position)
    if ['RJ', 'XRJ', 'FC'].include? type
      port_class = type
    else
      port_class = "SCSI"
    end
    link_to label,
        edit_port_url,
        {class: "port pull-left port#{port_class} #{port_data.try(:connection).try(:cable).present? ? port_data.connection.cable.color : '' }",
        id: port_data.try(:id),
        data: {url: edit_port_url,
               position: position,
               type: type,
               toggle: 'tooltip',
               placement: 'top',
               title: port_data.present? ? "#{port_data.vlans}" : ""}
    }
  end

end
