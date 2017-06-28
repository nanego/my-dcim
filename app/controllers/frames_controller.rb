class FramesController < ApplicationController
  include ServersHelper

  def show
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    @room = @frame.room
    @servers_per_frames = {}
    @servers = @frame.servers.includes(:gestion, :modele => :category, :card_types => :port_type, :cards_servers => [:composant, :ports])
    @agregated_ports_per_server = {}
    @servers.each do |s|
      islet = @frame.bay.islet
      @servers_per_frames[islet] ||= {}
      @servers_per_frames[islet][@frame.bay.lane] ||= {}
      @servers_per_frames[islet][@frame.bay.lane][@frame.bay] ||= {}
      @servers_per_frames[islet][@frame.bay.lane][@frame.bay][@frame] ||= []
      @servers_per_frames[islet][@frame.bay.lane][@frame.bay][@frame] << s

      @agregated_ports_per_server[s.id] = get_ports_per_bay_on_a_server(bay_id: s.frame.bay_id, server: s) if s.aggregate_ports?
    end
    @sums = calculate_ports_sums(@frame, @servers)

    respond_to do |format|
      format.html do
        render 'frames/show.html.erb'
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

  def new
    @frame = Frame.new
  end

  def edit
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
  end

  def update
    @frame = Frame.friendly.find(params[:id].to_s.downcase)
    respond_to do |format|
      if @frame.update(frame_params)
        format.html { redirect_to room_path(@frame.room), notice: 'Le châssis a été mis à jour.' }
        format.json { render :show, status: :ok, location: @frame }
      else
        format.html { render :edit }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @frame = Frame.new(frame_params)

    respond_to do |format|
      if @frame.save
        format.html { redirect_to frames_path, notice: 'Le châssis a été ajouté.' }
        format.json { render :show, status: :created, location: @frame }
      else
        format.html { render :new }
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
    params.require(:frame).permit(:name, :u, :room, :islet, :position, :switch_slot, :bay_id)
  end

end
