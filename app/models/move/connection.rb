# frozen_string_literal: true

class Move
  class Connection < ApplicationRecord
    has_changelog

    belongs_to :move
    belongs_to :port_from, class_name: "Port"
    belongs_to :port_to, class_name: "Port", optional: true

    scope :not_executed, -> { where(executed_at: nil) }

    def ports
      [port_from, port_to].compact
    end

    def execute!
      return if executed?

      transaction(requires_new: true) do
        port_from.connect_to_port(port_to, cable_name, cable_color, vlans)

        update!(executed_at: Time.zone.now)
      end
    end

    def executed?
      executed_at?
    end
  end
end
