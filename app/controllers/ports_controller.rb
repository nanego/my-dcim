# frozen_string_literal: true

class PortsController < ApplicationController
  before_action :set_port, only: %i[show update]

  def index
    if params[:frame_id].present?
      @frame = Frame.find_by_id(params[:frame_id])
      @frames = [@frame]
    elsif params[:room_id].present?
      @room = Room.find_by_id(params[:room_id])
      @frames = @room.frames
      if params[:islet].present?
        @frames = @frames.joins(:bay => :islet).where('islets.name = ?', params[:islet])
      elsif params[:bay_id].present?
        @frames = @frames.joins(:bay).where('bays.id = ?', params[:bay_id])
      end
    else
      @ports = Port.all
    end

    respond_to do |format|
      format.html
      format.txt { send_data Port.to_txt(@frames), filename: "#{DateTime.now.strftime("%Y%m%d")}-ports.txt" }
      format.csv { send_data Port.to_csv(@frames), filename: "#{DateTime.now.strftime("%Y%m%d")}-ports.csv"}
      format.json
    end
  end

  def show; end

  def create
    @port = Port.new(port_params)

    respond_to do |format|
      if @port.save
        format.json { render :show, status: :created, location: @port }
      else
        format.json { render json: @port.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if params[:id].present? && params[:id].to_i > 0
      redirect_to connections_edit_path(from_port_id: params[:id])
    else
      @port = Port.find_or_create_by(position: params['position'],
                          card_id: params['card_id'],
                          vlans: params['vlans'],
                          color: params['color'],
                          cablename: params['cablename'])
      redirect_to connections_edit_path(from_port_id: @port)
    end
  end

  def update
    respond_to do |format|
      if @port.update(port_params)
        format.html { redirect_to @port.card.server.frame, notice: 'Le port a été mis à jour.' }
        format.js
        format.json { render :show, status: :ok, location: @port.server }
      else
        format.html { render :edit }
        format.json { render json: @port.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @port = Port.find_by_id(params[:id])
    server = @port.card.server
    @port.destroy

    respond_to do |format|
      format.html { redirect_to server_path(server), notice: 'Le port a été supprimé' }
      format.json { head :no_content }
    end
  end

  private

  def set_port
    @port = Port.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def port_params
    params.required(:port).permit(:position, :card_id, :vlans, :color, :cablename)
  end
end
