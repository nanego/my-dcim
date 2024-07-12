# frozen_string_literal: true

module Visualization
  class NetworkCapacitiesController < ApplicationController
    def show
      @filter = Filter.new(params, %i[network_type islet_id])

      @islet = Islet.find(@filter.islet_id) if @filter.filled?
    end
  end
end
