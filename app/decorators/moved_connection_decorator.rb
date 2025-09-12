# frozen_string_literal: true

class MovedConnectionDecorator < ApplicationDecorator
  def description
    I18n.t("moved_connections.decorator.description",
           port_from_server: port_from.server.decorated.full_name,
           port_from_id:,
           port_to_server: port_to.server.decorated.full_name,
           port_to_id:,
           vlans:,
           cablename:,
           color:)
  end
end
