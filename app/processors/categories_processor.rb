# frozen_string_literal: true

class CategoriesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[id name modeles_count is_glpi_synchronizable].freeze

  sortable fields: SORTABLE_FIELDS
end
