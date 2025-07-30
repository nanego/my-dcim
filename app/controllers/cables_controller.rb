# frozen_string_literal: true

class CablesController < ApplicationController
  before_action :set_cable, only: :destroy

  def index
    @cables = Cable.includes(connections: %i[port server card],
                             cards: [:card_type],
                             card_types: [:port_type])
      .order(created_at: :desc)
    @filter = ProcessorFilter.new(@cables, params)
    authorize! @cables

    @pagy, @cables = pagy(@filter.results.distinct)
  end

  def destroy
    @cable.ports.each do |port|
      if @from_server.nil?
        @from_server = port.server
      else
        @to_server = port.server
      end
    end

    @cable.destroy

    respond_to do |format|
      format.html do
        redirect_to cables_path, notice: t(".flashes.destroyed")
      end

      format.js { render "connections/update" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cable
    authorize! @cable = Cable.find(params[:id])
  end
end
