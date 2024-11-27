# frozen_string_literal: true

class RoomHub < ApplicationRecord
  belongs_to :from_room, class_name: "Room"
  belongs_to :to_room, class_name: "Room"
  belongs_to :hub, class_name: "Server"

  validate :validate_network_types_values
  normalizes :network_types, with: ->(values) { values.compact_blank }

  private

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.any? { |n| Modele::Network::TYPES.include?(n) }

    errors.add(:network_types, :invalid)
  end
end
