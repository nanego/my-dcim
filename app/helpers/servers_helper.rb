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

  def ports_by_card(port_type:, port_quantity:,
                    ports_data:, card_server_id:)

    html = ""

    port_quantity.to_i.times do |index|

      port_data = ports_data.find_by(position: index+1)

      edit_port_url = port_data.try(:id) ? edit_port_path(port_data) : edit_port_path(id: 0, parent_id: card_server_id, parent_type: CardsServer.name, position: index+1)

      case port_type.name
        when 'RJ'

          html += link_to port_cablename(port_data),
                  edit_port_url,
                  class: "port pull-left portRJ #{port_data.present? ? port_data.color : '' }",
                  data: {url: edit_port_url,
                         position: index+1,
                         type: "RJ",
                         toggle: 'tooltip',
                         placement: 'top',
                         title: port_data.present? ? "#{port_data.vlans}" : ""
                  }

        when 'FC'

          html += link_to port_cablename(port_data),
                  edit_port_url,
                  class: "port pull-left portFC #{port_data.present? ? port_data.color : '' }",
                  data: {url: edit_port_url,
                         position: index+1,
                         type: "FC",
                         toggle: 'tooltip',
                         placement: 'top',
                         title: port_data.present? ? "#{port_data.vlans}" : ""
                  }

        else

          html += link_to "#{port_type.try(:name)} <BR> #{port_cablename(port_data)}".html_safe,
                  edit_port_url,
                  class: "port pull-left portSCSI #{port_data.present? ? port_data.color : '' }",
                  data: {url: edit_port_url,
                         position: index+1,
                         type: port_type.try(:name),
                         toggle: 'tooltip',
                         placement: 'top',
                         title: port_data.present? ? "#{port_data.vlans}" : ""
                  }


      end
    end

    html.html_safe

  end
end
