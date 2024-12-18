# frozen_string_literal: true

class ConnectionsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[ports.id cables.name servers.name cards.composant_id port_types.name].freeze

  map :port_ids, filter_with: :non_empty_array do |port_ids:|
    raw.joins(:port).where(ports: { id: port_ids })
  end

  map :cable_name do |cable_name:|
    raw.joins(:cable).where(cables: { name: cable_name })
  end

  map :server_ids, filter_with: :non_empty_array do |server_ids:|
    raw.joins(:server).where(servers: { id: server_ids })
  end

  map :card_query do |card_query:|
    name_condition = Card.arel_table[:name].matches("%#{card_query}%")
    card_type_condition = CardType.arel_table[:name].matches("%#{card_query}%")
    slot_condition = Composant.arel_table[:name].matches("%#{card_query}%")
    combined_conditions = name_condition.or(card_type_condition).or(slot_condition)
    raw.joins(:card, :card_type, card: :composant).where(combined_conditions)
  end

  map :port_type_ids, filter_with: :non_empty_array do |port_type_ids:|
    raw.joins(:port_type).where(port_types: { id: port_type_ids })
  end

  sortable fields: SORTABLE_FIELDS
end
