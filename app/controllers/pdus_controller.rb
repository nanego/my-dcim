# frozen_string_literal: true

class ServersController < ServersController
  def index
    @servers = Server.only_puds.includes(:frame, :room, :islet, bay: :frames, modele: :category)
      .references(:room, :islet, :bay, modele: :category)
      .order(:name)
    @filter = ProcessorFilter.new(@servers, params)

    @servers = @filter.results
    @search_params = search_params

    respond_to do |format|
      format.json
      format.html { @pagy, @servers = pagy(@servers) }
    end
  end
end
