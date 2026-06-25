# frozen_string_literal: true

class PowerDistributionUnitsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name rooms.name islets.name bays.id frames.id power_distribution_unit_types.name manufacturers.name].freeze

  map :q do |q:|
    raw.where(PowerDistributionUnit.arel_table[:name].matches("%#{q}%"))
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(:room).where(rooms: { id: room_ids })
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.joins(:islet).where(islets: { id: islet_ids })
  end

  map :bay_ids, filter_with: :non_empty_array do |bay_ids:|
    raw.joins(:bay).where(bays: { id: bay_ids })
  end

  map :frame_ids, filter_with: :non_empty_array do |frame_ids:|
    raw.where(frame_id: frame_ids)
  end

  map :type_ids, filter_with: :non_empty_array do |type_ids:|
    raw.where(type_id: type_ids)
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.joins(:manufacturer).where(manufacturer: { id: manufacturer_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
