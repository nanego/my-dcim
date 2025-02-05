# frozen_string_literal: true

class RoomHub < ApplicationRecord
  belongs_to :server_a, class_name: "Server"
  belongs_to :server_b, class_name: "Server"

  validate :validate_network_types_values
  normalizes :network_types, with: ->(values) { values.compact_blank }

  def self.for_room(rooms, network_types:)
    frame = Frame.joins(bay: :islet).where(bay: { islets: { room: rooms } })

    joins(:server_a, :server_b)
      .where("room_hubs.network_types && ARRAY[?]::varchar[]", network_types)
      .and(
        where(server_a: { frame_id: frame })
          .or(where(server_b: { frame_id: frame }))
      )
  end

  private

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.any? { |n| Modele::Network::TYPES.include?(n) }

    errors.add(:network_types, :invalid)
  end
end
