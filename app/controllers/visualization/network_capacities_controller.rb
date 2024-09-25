# frozen_string_literal: true

module Visualization
  class NetworkCapacitiesController < BaseController
    def show
      @filter = Filter.new(params, %i[network_type islet_id])
      @filter_filled = @filter.filled?

      unless @filter.filled?
        islet_id = Islet.sorted.not_empty.has_name.distinct.first.id

        redirect_to islet_id:, network_type: :gbe
      end

      load_data! if turbo_frame_request?
    end

    private

    def load_data!
      @islet = Islet.find(@filter.islet_id)
      @room = @islet.room
      @network = @filter.network_type # TODO: take from params and raise error if not good
      @bays = @islet.bays.sorted
      @servers = Server.where(frame_id: Frame.select(:id).group(:id).where(bay_id: @bays))

      fresh_when last_modified: [@islet.updated_at, @room.updated_at, @bays.maximum(:updated_at), @servers.maximum(:updated_at)].max
    end
  end
end
