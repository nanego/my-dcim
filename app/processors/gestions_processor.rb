# frozen_string_literal: true

class GestionsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name servers_count].freeze

  sortable fields: SORTABLE_FIELDS
end
