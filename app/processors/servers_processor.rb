# frozen_string_literal: true

class ServersProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name numero categories.name rooms.name islets.name bays.id].freeze

  map :q do |q:|
    server_table = Server.arel_table
    name_condition = server_table[:name].matches("%#{q}%")
    numero_condition = server_table[:numero].matches("%#{q}%")
    id_condition = server_table[:id].eq(q.to_i)
    combined_conditions = name_condition.or(numero_condition).or(id_condition)
    raw.where(combined_conditions)
  end

  map :frame_ids, filter_with: :non_empty_array do |frame_ids:|
    raw.where(frame_id: frame_ids)
  end

  map :bay_ids, filter_with: :non_empty_array do |bay_ids:|
    raw.joins(:bay).where(bay: { id: bay_ids })
  end

  map :islet_ids, filter_with: :non_empty_array do |islet_ids:|
    raw.joins(:islet).where(islet: { id: islet_ids })
  end

  map :room_ids, filter_with: :non_empty_array do |room_ids:|
    raw.joins(:room).where(room: { id: room_ids })
  end

  map :modele_ids, filter_with: :non_empty_array do |modele_ids:|
    raw.where(modele_id: modele_ids)
  end

  map :gestion_ids, filter_with: :non_empty_array do |gestion_ids:|
    raw.where(gestion_id: gestion_ids)
  end

  map :domaine_ids, filter_with: :non_empty_array do |domaine_ids:|
    raw.where(domaine_id: domaine_ids)
  end

  map :cluster_ids, filter_with: :non_empty_array do |cluster_ids:|
    raw.where(cluster_id: cluster_ids)
  end

  map :stack_id do |stack_id:|
    raw.where(stack_id: stack_id)
  end

  sortable fields: SORTABLE_FIELDS do
    # having "name" do |sort: "asc"|
    #   raise "Possible injection: #{sort}" unless SORT_ORDERS.include?(sort)

    #   raw.order(name: sort)
    # end
  end
end
