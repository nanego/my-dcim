# frozen_string_literal: true

class ConnectionsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[ports.id cables.name servers.name cards.composant_id port_types.name].freeze

  map :port_ids, filter_with: :non_empty_array do |port_ids:|
    raw.joins(:port).where(ports: { id: port_ids })
  end

  map :cable_ids, filter_with: :non_empty_array do |cable_ids:|
    raw.joins(:cable).where(cables: { id: cable_ids })
  end

  map :server_ids, filter_with: :non_empty_array do |server_ids:|
    raw.joins(:server).where(servers: { id: server_ids })
  end

  map :card_ids, filter_with: :non_empty_array do |card_ids:|
    raw.joins(:card).where(cards: { id: card_ids })
  end

  map :port_type_ids, filter_with: :non_empty_array do |port_type_ids:|
    raw.joins(:port_type).where(port_types: { id: port_type_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
