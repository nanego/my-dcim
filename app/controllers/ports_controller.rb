class PortsController < ApplicationController

  def index
    if params[:frame_id].present?
      @frame = Frame.find_by_id(params[:frame_id])
      @frames = [@frame]
    else
      @room = Room.find_by_id(params[:room_id])
      @frames = @room.frames
      if params[:islet].present?
        @frames = @frames.joins(:bay => :islet).where('islets.name = ?', params[:islet])
      end
    end
  end

  def edit
    if params[:id].present? && params[:id].to_i > 0
      @port = Port.find_by_id(params[:id])
    else
      @port = Port.create(position: params['position'],
                          cards_server_id: params['cards_server_id'],
                          vlans: params['vlans'],
                          color: params['color'],
                          cablename: params['cablename'])
    end

    respond_to do |format|
      format.js {render layout: false, content_type: 'text/javascript' }
      format.html
    end

  end

  def update
    @port = Port.find_by_id(params[:id])
    respond_to do |format|
      if @port.update(port_params)
        format.html { redirect_to @port.cards_server.server.frame, notice: 'Le port a été mis à jour.' }
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
    server = @port.cards_server.server
    @port.destroy
    respond_to do |format|
      format.html { redirect_to server_path(server), notice: 'Le port a été supprimé' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def port_params
      params.required(:port).permit(:position, :cards_server_id, :vlans, :color, :cablename)
    end

end
