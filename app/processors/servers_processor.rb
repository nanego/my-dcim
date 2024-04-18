# frozen_string_literal: true

class ServersProcessor < Rubanok::Processor
  map :q do |q:|
    raw.where(Server.arel_table[:name].matches("%#{q}%"))
      .or(raw.where(id: q))
  end

  map :cluster_id do |cluster_id:|
    raw.where(cluster_id: cluster_id)
  end

  map :bay_id do |bay_id:|
    raw.where(bay_id: bay_id) # TODO
  end
end
