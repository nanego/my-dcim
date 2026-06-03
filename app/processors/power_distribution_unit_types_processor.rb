# frozen_string_literal: true

class PowerDistributionUnitTypesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name manufacturers.name].freeze

  map :q do |q:|
    raw.where(PowerDistributionUnitType.arel_table[:name].matches("%#{q}%"))
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.joins(:manufacturer).where(manufacturer_id: manufacturer_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
