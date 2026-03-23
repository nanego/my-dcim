# frozen_string_literal: true

class ManufacturersProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name modeles_count].freeze

  sortable fields: SORTABLE_FIELDS
end
