# frozen_string_literal: true

class ContactRolesProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[id name description].freeze

  sortable fields: SORTABLE_FIELDS
end
