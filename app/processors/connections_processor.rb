# frozen_string_literal: true

class ConnectionsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[cables.name ports.id].freeze

  map :server_ids, filter_with: :non_empty_array do |server_ids:|
    raw.joins(:server).where(servers: { id: server_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
