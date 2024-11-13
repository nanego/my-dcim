# frozen_string_literal: true

class ContactAssignment < ApplicationRecord
  belongs_to :site
  belongs_to :contact
  belongs_to :contact_role

  def to_s
    "#{site} - #{contact} #{contact_role}"
  end
end
