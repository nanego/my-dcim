# frozen_string_literal: true

class DomainsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name servers_count].freeze

  sortable fields: SORTABLE_FIELDS
end
