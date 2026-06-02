# frozen_string_literal: true

class Move
  class ConnectionDecorator < ApplicationDecorator
    def description
      I18n.t("move_connections.decorator.description",
             port_from_server: port_from.server.decorated.full_name,
             port_from_id:,
             port_to_server: port_to&.server&.decorated&.full_name, # rubocop:disable Style/SafeNavigationChainLength
             port_to_id:,
             vlans:,
             cable_name:,
             cable_color:)
    end
  end
end
