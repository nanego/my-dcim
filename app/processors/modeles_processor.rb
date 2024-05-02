# frozen_string_literal: true

class ModelesProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name servers_count].freeze

  map :q do |q:|
    raw.where(Modele.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :architecture_id do |architecture_id:|
    raw.where(architecture_id:)
  end

  map :category_id do |category_id:|
    raw.where(category_id:)
  end

  map :manufacturer_id do |manufacturer_id:|
    raw.where(manufacturer_id:)
  end

  sortable fields: SORTABLE_FIELDS
end
