# frozen_string_literal: true

class DomainesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name servers_count].freeze

  sortable fields: SORTABLE_FIELDS
end
