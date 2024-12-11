# frozen_string_literal: true

class CablesController < ApplicationController
  before_action :set_cable, only: [:destroy]

  def index
    @cables = sorted(Cable.includes(:connections, connections: [:port]).order(created_at: :desc))
    @pagy, @cables = pagy(@cables)
  end

  def destroy
    port_id = params[:redirect_to_port_id]

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
        redirect_to connections_edit_path(from_port_id: port_id), notice: t(".flashes.destroyed")
      end

      format.js { render 'connections/update' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cable
    @cable = Cable.find(params[:id])
  end
end
