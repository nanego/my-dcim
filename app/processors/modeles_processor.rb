# frozen_string_literal: true

class ModelesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name servers_count].freeze

  map :q do |q:|
    raw.where(Modele.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :architecture_ids, filter_with: :non_empty_array do |architecture_ids:|
    raw.where(architecture_id: architecture_ids)
  end

  map :category_ids, filter_with: :non_empty_array do |category_ids:|
    raw.where(category_id: category_ids)
  end

  map :manufacturer_ids, filter_with: :non_empty_array do |manufacturer_ids:|
    raw.where(manufacturer_id: manufacturer_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
