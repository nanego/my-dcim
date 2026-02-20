# frozen_string_literal: true

class CategoriesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[id name modeles_count glpi_sync].freeze

  sortable fields: SORTABLE_FIELDS
end
