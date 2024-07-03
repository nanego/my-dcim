module Visualization
  class InfrastructuresController < ApplicationController
    def show
      @sites = Site.joins(:rooms).includes(rooms: { islets: { bays: :frames } })
                   .order(:position).distinct
    end
  end
end
