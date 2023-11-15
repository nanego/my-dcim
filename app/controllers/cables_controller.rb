# frozen_string_literal: true

class CablesController < ApplicationController
  before_action :set_cable, only: %i[show update destroy]

  def index
    @cables = Cable.all
  end

  def show; end

  def create
    @cable = Cable.new(cable_params)

    respond_to do |format|
      if @cable.save
       format.json { render :show, status: :created, location: @cable }
      else
        format.json { render json: @cable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cable.update(cable_params)
        format.json { render :show, status: :ok, location: @cable }
      else
        format.json { render json: @cable.errors, status: :unprocessable_entity }
      end
    end
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
        redirect_to connections_edit_path(from_port_id: port_id), notice: 'Connection a bien été supprimé.'
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

  def cable_params
    params.require(:cable).permit(:name, :color, :comments, :special_case)
  end
end
