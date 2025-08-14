# frozen_string_literal: true

class CablesProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[special_case].freeze

  map :cable_name do |cable_name:|
    raw.where(name: cable_name)
  end

  map :special_case do |special_case:|
    raw.where(special_case:)
  end

  map :colors, filter_with: :non_empty_array do |colors:|
    raw.where(color: colors)
  end

  map :comments do |comments:|
    raw.where(Cable.arel_table[:comments].matches("%#{comments}%"))
  end

  map :vlans do |vlans:|
    raw.joins(:ports).where(Port.arel_table[:vlans].matches("%#{vlans}%"))
  end

  map :server_ids, filter_with: :non_empty_array do |server_ids:|
    raw.joins(:servers).where(servers: { id: server_ids })
  end

  map :port_type_ids, filter_with: :non_empty_array do |port_type_ids:|
    raw.joins(:port_types).where(port_types: { id: port_type_ids })
  end

  map :card_query do |card_query:|
    name_condition = Card.arel_table[:name].matches("%#{card_query}%")
    card_type_condition = CardType.arel_table[:name].matches("%#{card_query}%")
    slot_condition = Composant.arel_table[:name].matches("%#{card_query}%")
    combined_conditions = name_condition.or(card_type_condition).or(slot_condition)
    raw.joins(:cards, :card_types, cards: :composant).where(combined_conditions)
  end

  sortable fields: SORTABLE_FIELDS do
    having "comments" do |sort: "asc"|
      valid_sort_value!(sort)

      raw.reorder("comments #{sort.upcase} nulls last")
    end
  end
end
