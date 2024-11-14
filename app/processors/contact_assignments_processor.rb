# frozen_string_literal: true

class ContactAssignmentsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[id site_id contact_id contact_role_id].freeze

  map :site_id do |site_id:|
    raw.where(site_id: site_id)
  end

  map :contact_id do |contact_id:|
    raw.where(contact_id: contact_id)
  end

  sortable fields: SORTABLE_FIELDS
end
