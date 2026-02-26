# frozen_string_literal: true

class CablesController < ApplicationController
  before_action :set_server, only: :index
  before_action :set_cable, only: :destroy

  def index
    if @server
      authorize! @cables = @server.cables.includes(:cards, :port_types, ports: { server: { modele: :category } })
      @cables = @cables.sorted
    else
      authorize! @cables = scoped_cables.includes(connections: %i[port server card],
                                                  cards: [:card_type],
                                                  card_types: [:port_type])
        .order(created_at: :desc)
      @filter = ProcessorFilter.new(@cables, params)

      @pagy, @cables = pagy(@filter.results.distinct)
    end
  end

  destroy_confirmation
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
        redirect_back_to_param_or cables_path, notice: t(".flashes.destroyed")
      end

      format.js { render "connections/update" }
      format.json { head :no_content }
    end
  end

  private

  def scoped_cables
    authorized_scope(Cable.all)
  end

  def set_server
    return unless params[:server_id]

    @server = Server.find(params[:server_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_cable
    authorize! @cable = scoped_cables.find(params[:id])
  end
end
