# frozen_string_literal: true

class MovesProjectsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[name created_at updated_at created_by].freeze

  sortable fields: SORTABLE_FIELDS do
    having "created_by" do |sort: "asc"|
      valid_sort_value!(sort)

      raw.left_joins(:created_by).reorder(users: { name: sort, email: sort })
    end
  end
end
