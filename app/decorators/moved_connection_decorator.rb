# frozen_string_literal: true

class MovedConnectionDecorator < ApplicationDecorator
  def description
    MovedConnection.human_attribute_name(:description,
                                         from_server_category: port_from.server.try(:modele).try(:category),
                                         from_server: port_from.server,
                                         from_port_id: port_from_id,
                                         to_server_category: port_to.try(:server).try(:modele).try(:category),
                                         to_server: port_to.try(:server),
                                         to_port_id: port_to_id,
                                         vlans:,
                                         cablename:,
                                         color:)
  end
end
