# frozen_string_literal: true

class ServersProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name categories.name rooms.name islets.name bays.id].freeze

  map :q do |q:|
    raw.where(Server.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :frame_id do |frame_id:|
    raw.where(frame_id: frame_id)
  end

  map :bay_id do |bay_id:|
    raw.joins(:bay).where(bay: { id: bay_id })
  end

  map :islet_id do |islet_id:|
    raw.joins(:islet).where(islet: { id: islet_id })
  end

  map :room_id do |room_id:|
    raw.joins(:room).where(room: { id: room_id })
  end

  map :modele_id do |modele_id:|
    raw.where(modele_id: modele_id)
  end

  map :gestion_id do |gestion_id:|
    raw.where(gestion_id: gestion_id)
  end

  map :domaine_id do |domaine_id:|
    raw.where(domaine_id: domaine_id)
  end

  map :cluster_id do |cluster_id:|
    raw.where(cluster_id: cluster_id)
  end

  sortable fields: SORTABLE_FIELDS do
    # having "name" do |sort: "asc"|
    #   raise "Possible injection: #{sort}" unless SORT_ORDERS.include?(sort)

    #   raw.order(name: sort)
    # end
  end
end
