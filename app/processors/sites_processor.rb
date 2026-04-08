# frozen_string_literal: true

class SitesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name position rooms_count].freeze

  sortable fields: SORTABLE_FIELDS
end
