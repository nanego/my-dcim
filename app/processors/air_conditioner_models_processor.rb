# frozen_string_literal: true

class AirConditionerModelsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name manufacturers.name air_conditioners_count].freeze

  map :q do |q:|
    raw.where(AirConditionerModel.arel_table[:name].matches("%#{q}%"))
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.joins(:manufacturer).where(manufacturers: { id: manufacturer_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
