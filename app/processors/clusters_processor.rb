# frozen_string_literal: true

class ClustersProcessor < Rubanok::Processor
  map :name do |name:|
    raw.where(Cluster.arel_table[:name].matches("%#{name}%"))
  end
end
