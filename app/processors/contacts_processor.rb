# frozen_string_literal: true

class ContactsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[id first_name last_name phone_number email organization].freeze

  sortable fields: SORTABLE_FIELDS do
    having "full_name" do |sort: "asc"|
      valid_sort_value!(sort)

      raw.order(first_name: sort, last_name: sort)
    end
  end
end
