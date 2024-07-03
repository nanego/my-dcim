module Visualization
  class NetworkCapacitiesController < ApplicationController
    def show
      @sites = Site.joins(:rooms).includes(rooms: { islets: { bays: :frames } })
                   .order(:position).distinct

      @filter = Filter.new(params, %i[network_type islet_id])
    end
  end
end
