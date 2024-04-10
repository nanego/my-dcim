# frozen_string_literal: true

class ServersProcessor < Rubanok::Processor
  map :name do |name:|
    raw.where(Server.arel_table[:name].matches("%#{name}%"))
  end

  map :cluster_id do |cluster_id:|
    raw.where(cluster_id: cluster_id)
  end
end
