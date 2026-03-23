# frozen_string_literal: true

class PortTypesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name power card_types_count].freeze

  sortable fields: SORTABLE_FIELDS
end
