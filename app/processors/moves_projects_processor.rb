# frozen_string_literal: true

class MovesProjectsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name created_at updated_at created_by].freeze

  sortable fields: SORTABLE_FIELDS
end
