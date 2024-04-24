# frozen_string_literal: true

class UsersProcessor < ApplicationProcessor
  SORTABLE_FIELDS = %w[id email last_sign_in_at created_at role].freeze

  match :suspended do
    having "true" do
      raw.suspended
    end

    default do
      raw.unsuspended
    end
  end

  sortable fields: SORTABLE_FIELDS
end
