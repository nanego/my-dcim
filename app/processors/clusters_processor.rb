# frozen_string_literal: true

class ClustersProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[name servers_count].freeze

  map :q do |q:|
    raw.where(Cluster.arel_table[:name].matches("%#{q}%"))
  end

  sortable fields: SORTABLE_FIELDS
end
