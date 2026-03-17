# frozen_string_literal: true

class AirConditionerModelsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name].freeze

  map :q do |q:|
    raw.where(AirConditionerModel.arel_table[:name].matches("%#{q}%"))
  end

  sortable fields: SORTABLE_FIELDS
end
