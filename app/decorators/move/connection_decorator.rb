# frozen_string_literal: true

class Move
  class ConnectionDecorator < ApplicationDecorator
    def status_to_badge_component
      color = executed_at.nil? ? :primary : :success
      locale_key = executed_at.nil? ? :planned : :executed
      text = Move::Connection.human_attribute_name("status.#{locale_key}")

      BadgeComponent.new(text, color:, variant: :pill)
    end

    def description
      I18n.t("move_connections_decorator.description",
             port_from_server: port_from.server.decorated.full_name,
             port_from_id:,
             port_to_server: port_to&.server&.decorated&.full_name, # rubocop:disable Style/SafeNavigationChainLength
             port_to_id:,
             vlans:,
             cable_name:,
             cable_color:)
    end

    def display_name
      description
    end
  end
end
