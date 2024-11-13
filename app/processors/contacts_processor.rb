# frozen_string_literal: true

class ContactsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[id first_name last_name phone_number email].freeze

  sortable fields: SORTABLE_FIELDS
end
