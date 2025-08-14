# frozen_string_literal: true

class AirConditionersProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[rooms.name islets.name name].freeze

  map :q do |q:|
    raw.where(AirConditioner.arel_table[:name].matches("%#{q}%"))
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(bay: { islet: :room }).where(rooms: { id: room_ids })
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.joins(bay: :islet).where(islets: { id: islet_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
