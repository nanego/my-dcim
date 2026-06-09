# frozen_string_literal: true

class PowerDistributionUnitProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name power_distribution_unit_types.name manufacturers.name bays.name islets.name rooms.name].freeze

  map :q do |q:|
    raw.where(PowerDistributionUnit.arel_table[:name].matches("%#{q}%"))
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(:room).where(room_id: room_ids)
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.joins(:islet).where(islet_id: islet_ids)
  end

  map :bays_ids, filter_with: :non_empty_array do |bays_ids:|
    raw.joins(:bay).where(bay_id: bays_ids)
  end

  map :power_distribution_unit_type_ids, filter_with: :non_empty_array do |power_distribution_unit_type_ids:|
    raw.joins(:power_distribution_unit_type).where(power_distribution_unit_type_id: power_distribution_unit_type_ids)
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.joins(:manufacturer).where(manufacturer_id: manufacturer_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
