# frozen_string_literal: true

class NetsightSyncResultsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[servers.name if_name status frames.name].freeze

  map :statuses, filter_with: :non_empty_array do |statuses:|
    raw.where(status: statuses)
  end

  map :frame_ids, filter_with: :non_empty_array do |frame_ids:|
    raw.where(servers: { frame_id: frame_ids })
  end

  map :server_name do |server_name:|
    raw.where(Server.arel_table[:name].matches("%#{server_name}%"))
  end

  sortable fields: SORTABLE_FIELDS
end
