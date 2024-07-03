# frozen_string_literal: true

module Visualization
  class InfrastructuresController < ApplicationController
    def show
      @filter = Filter.new(params, %i[network_type islet_id stack_ids])

      @islet = Islet.find(@filter.islet_id) if @filter.filled?
    end
  end
end
