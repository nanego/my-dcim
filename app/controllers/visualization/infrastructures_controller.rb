# frozen_string_literal: true

module Visualization
  class InfrastructuresController < ApplicationController
    def show
      @filter = Filter.new(params, %i[network_type islet_id])

      unless @filter.filled?
        @filter.islet_id = Islet.sorted.not_empty.has_name.distinct.first.id
        @filter.network_type = :gbe
      end

      @islet = Islet.find(@filter.islet_id) if @filter.filled?
    end
  end
end
