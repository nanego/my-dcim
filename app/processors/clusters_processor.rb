# frozen_string_literal: true

class ClustersProcessor < Rubanok::Processor
  map :q do |q:|
    raw.where(Cluster.arel_table[:name].matches("%#{q}%"))
  end
end
