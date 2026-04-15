# frozen_string_literal: true

class ManagersProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name servers_count].freeze

  sortable fields: SORTABLE_FIELDS
end
