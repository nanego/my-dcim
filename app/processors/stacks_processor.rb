# frozen_string_literal: true

class StacksProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name color servers_count].freeze

  sortable fields: SORTABLE_FIELDS
end
