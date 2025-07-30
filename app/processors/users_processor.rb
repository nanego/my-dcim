# frozen_string_literal: true

class UsersProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[id name email last_sign_in_at created_at is_admin role].freeze

  match :filter, activate_always: true do
    having "suspended" do
      raw.suspended
    end

    default do
      raw.unsuspended
    end
  end

  sortable fields: SORTABLE_FIELDS
end
