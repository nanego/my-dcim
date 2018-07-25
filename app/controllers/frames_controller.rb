class FramesController < ApplicationController
  include ServersHelper
  include RoomsHelper

  def show
    @frame = Frame.all.includes(:servers => [:modele => [:category, :composants], :cards => [:composant, :ports => [:connection => [:cable => :connections]], :card_type => [:port_type]]], :bay => [:islet => [:room]]).friendly.find(params[:id].to_s.downcase)
    @room = @frame.room
    @sums = { @frame.id => {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0} }
    @frame.servers.each do |s|
      s.ports_per_type.each do |type, sum|
        @sums[@frame.id][type] = @sums[@frame.id][type].to_i + sum
      end
    end

    respond_to do |format|
      format.html do
        render 'frames/show.html.erb'
      end
      format.pdf do
        render layout: 'pdf.html',
               template: "frames/show.pdf.erb",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data @frame.to_txt }
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
    head :ok
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

  def network
    # Set frames for this network
    @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:id].to_s.downcase)
    @coupled_frame = @frame.other_frame
    if @coupled_frame.present?
      @network_frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
    else
      @network_frame = @frame
      @frame = Frames::IncludingServersQuery.call(Frame).friendly.find(params[:network_frame_id].to_s.downcase)
      @coupled_frame = @frame.other_frame
    end

    @frames = [@frame, @coupled_frame, @network_frame]
    @servers_per_frames = {}
    @sums = {}

    @frames.each do |frame|
      islet = "Vue réseau"
      @servers_per_frames[islet] ||= {}
      @servers_per_frames[islet][0] ||= {}
      @servers_per_frames[islet][0][frame.bay] ||= {}
      @servers_per_frames[islet][0][frame.bay][frame] ||= []
      frame.servers.each do |s|
        @servers_per_frames[islet][0][frame.bay][frame] << s
      end
      @sums.merge!(calculate_ports_sums(frame, frame.servers))
    end

    respond_to do |format|
      format.html do
        render 'frames/network.html.erb'
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def frame_params
    params.require(:frame).permit(:name, :u, :room, :islet, :position, :switch_slot, :bay_id)
  end

end
