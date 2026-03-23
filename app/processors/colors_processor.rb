# frozen_string_literal: true

class ColorsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[code parent_type parent_id].freeze

  sortable fields: SORTABLE_FIELDS
end
