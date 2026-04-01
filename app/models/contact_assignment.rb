# frozen_string_literal: true

class ContactAssignment < ApplicationRecord
  has_changelog associated_to: %i[contact]

  belongs_to :site
  belongs_to :contact, touch: true
  belongs_to :contact_role

  delegate :name, to: :site, prefix: true
  delegate :name, to: :contact_role, prefix: true

  def to_s
    "#{site} - #{contact} #{contact_role}"
  end
end
