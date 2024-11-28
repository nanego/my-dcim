# frozen_string_literal: true

class CardTypesProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name port_type_id port_quantity].freeze

  map :q do |q:|
    raw.where(CardType.arel_table[:name].matches("%#{q}%"))
  end

  map :port_type_ids, filter_with: :non_empty_array do |port_type_ids:|
    raw.where(port_type_id: port_type_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
