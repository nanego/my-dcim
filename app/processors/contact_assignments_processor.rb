# frozen_string_literal: true

class ContactAssignmentsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[id site_id contact_id contact_role_id].freeze

  map :site_ids, filter_with: :non_empty_array do |site_ids:|
    raw.where(site_id: site_ids)
  end

  map :contact_ids, filter_with: :non_empty_array do |contact_ids:|
    raw.where(contact_id: contact_ids)
  end

  sortable fields: SORTABLE_FIELDS
end
