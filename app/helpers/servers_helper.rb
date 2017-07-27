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
    if port_data.present? && port_data.cablename.present?
      port_data.cablename
    else
      ""
    end
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, card_id:)
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect {|p| p.position == index+1}
      html += link_to_port(index+1, port_data, port_type, card_id)
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
    edit_port_url = port_data.try(:id) ? edit_port_path(port_data) : edit_port_path(id: 0, card_id: card_id, position: position)
    if ['RJ', 'XRJ', 'FC'].include? type
      port_class = type
    else
      port_class = "SCSI"
    end
    link_to label,
        edit_port_url,
        class: "port pull-left port#{port_class} #{port_data.present? ? port_data.color : '' }",
        data: {url: edit_port_url,
               position: position,
               type: type,
               toggle: 'tooltip',
               placement: 'top',
               title: port_data.present? ? "#{port_data.vlans}" : ""
    }
  end

  def get_ports_per_bay_on_a_server(bay_id:, server:)
    connections_identifier = server.cards.map(&:connections_identifier)
    if connections_identifier.any?
      Port.joins(:card => [:card_type, :server])
          .joins('INNER JOIN "port_types" ON "card_types"."port_type_id" = "port_types"."id" AND "port_types".name <> \'SAS\'')
          .joins('INNER JOIN "frames" ON "frames".id = "servers"."frame_id" AND "bay_id" = '+ bay_id.to_s)
          .includes(:card)
          .where('substring(cablename from \'.\') IN (?)', connections_identifier.uniq.compact)
          .order('cablename asc')
          .to_a
    else
      []
    end
  end

end
