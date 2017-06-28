class FramesController < ApplicationController
  include ServersHelper

  def show
    @frame = Frame.all.includes(:servers => [:modele => [:category, :composants], :cards => [:composant, :ports, :card_type => [:port_type]]], :bay => [:islet => [:room]]).friendly.find(params[:id].to_s.downcase)
    @room = @frame.room
    @sums = { @frame.id => {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0} }
    @agregated_ports_per_server = {}
    @frame.servers.each do |s|
      s.ports_per_type.each do |type, sum|
        @sums[@frame.id][type] = @sums[@frame.id][type].to_i + sum
      end
      @agregated_ports_per_server[s.id] = get_ports_per_bay_on_a_server(bay_id: @frame.bay_id, server: s) if s.aggregate_ports?
    end

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
