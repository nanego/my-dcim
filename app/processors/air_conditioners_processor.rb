# frozen_string_literal: true

class AirConditionersProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[rooms.name islets.name name].freeze

  map :q do |q:|
    raw.where(AirConditioner.arel_table[:name].matches("%#{q}%"))
  end

  map :room_id do |room_id:|
    raw.joins(:room).where(rooms: { id: room_id })
  end

  map :islet_id do |islet_id:|
    raw.where(islet_id: islet_id)
  end

  sortable fields: SORTABLE_FIELDS
end
