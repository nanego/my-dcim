class FramesController < ApplicationController
  include ServersHelper

  def show
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    @room = @frame.room
    @servers_per_frames = {}
    @servers = @frame.servers.includes(:gestion, :modele => :category, :cards => :port_type, :cards_servers => [:composant, :ports])
    @servers.each do |s|
      islet = @frame.islet
      @servers_per_frames[islet] ||= {}
      @servers_per_frames[islet][@frame.bay] ||= {}
      @servers_per_frames[islet][@frame.bay][@frame] ||= []
      @servers_per_frames[islet][@frame.bay][@frame] << s
    end
    @sums = calculate_ports_sums(@frame, @servers)

    respond_to do |format|
      format.html do
        render 'rooms/show.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "rooms/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data Frame.to_txt(@servers_per_frames) }
    end
  end

  def edit
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
  end

  def update
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    respond_to do |format|
      if @frame.update(frame_params)
        format.html { redirect_to room_path(@frame.room), notice: 'frame was successfully updated.' }
        format.json { render :show, status: :ok, location: @frame }
      else
        format.html { render :edit }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort
    params[:frame].each_with_index do |id, index|
      Frame.where(id: id).update_all(position: index+1)
    end if params[:frame].present?
    render nothing: true
  end

  def index
    @frames = Frame.includes(:bay => {:islet => :room})
  end

  def destroy
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    @frame.destroy
    respond_to do |format|
      format.html { redirect_to frames_url, notice: 'Frame was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def frame_params
    params.require(:frame).permit(:title, :u, :room, :islet, :position, :switch_slot)
  end

end
