# frozen_string_literal: true

class IsletsController < ApplicationController
  include RoomsHelper

  before_action :set_islet, only: [:show, :edit, :update, :destroy]

  def index
    @islets = sorted Islet.joins(:site, :room).order('rooms.site_id asc, rooms.position asc, islets.name asc')
  end

  def show
    return @islet if request.format.html?

    frames = Frames::IncludingServersQuery.call(@islet.frames)
    @room = @islet.room
    @servers_per_frames = {}

    sorted_frames_per_islet(frames, params[:view]).each do |frame|
      room = frame.bay.islet.room_id
      islet = frame.bay.islet.name
      @servers_per_frames[room] ||= {}
      @servers_per_frames[room][islet] ||= {}
      @servers_per_frames[room][islet][frame.bay.lane] ||= {}
      @servers_per_frames[room][islet][frame.bay.lane][frame.bay] ||= {}
      @servers_per_frames[room][islet][frame.bay.lane][frame.bay][frame] ||= []
      frame.servers.each do |s|
        @servers_per_frames[room][islet][frame.bay.lane][frame.bay][frame] << s
      end
    end

    respond_to do |format|
      format.json
      format.pdf do
        render template: "rooms/show",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data Frame.to_txt(@servers_per_frames[@room.id], params[:bg]) }
    end
  end

  # GET /islets/new
  def new
    @islet = Islet.new
  end

  # GET /islets/1/edit
  def edit; end

  # POST /islets
  # POST /islets.json
  def create
    @islet = Islet.new(islet_params)

    respond_to do |format|
      if @islet.save
        format.html { redirect_to islets_url, notice: t('.flashes.created') }
        format.json { render :show, status: :created, location: @islet }
      else
        format.html { render :new }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /islets/1
  # PATCH/PUT /islets/1.json
  def update
    respond_to do |format|
      if @islet.update(islet_params)
        format.html { redirect_to islets_url, notice: t('.flashes.updated') }
        format.json { render :show, status: :ok, location: @islet }
      else
        format.html { render :edit }
        format.json { render json: @islet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /islets/1
  # DELETE /islets/1.json
  def destroy
    if @islet.destroy
      respond_to do |format|
        format.html { redirect_to islets_url, notice: t('.flashes.destroyed') }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to islets_url, alert: @islet.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  # TODO
  def infrastructure
    @room = Room.friendly.find(params[:room_id])
    @islet = @room.islets.find(params[:id])

    @servers = Server.includes(:frame, :stack, :ports, :cards => [:ports])
      .where.not(network_types: [])
    # .includes(:cards, :ports => [:connection => [:port, :cable =>[:connections => [:port => :card]]]]).
    @concentrateurs_ids = [383, 384, 1043, 1044]
    @concentrateurs = Server.where(id: @concentrateurs_ids).includes(:ports => :connection, :cards => [:ports => :connection])
    @switchs_lan_ids = @concentrateurs_ids | @servers.pluck(:id) # Switch LAN
    # TODO: Remove hard-coded values
    @hubs = {}

    unless Rails.env.test?
      @hubs = { "gbe" => { 4 => Server.find(383), 3 => Server.find(384) }, "10gbe" => { 4 => Server.find(1043), 3 => Server.find(1044) } } # Concentrateurs per room
    end

    @connections = {}
    @stacks = @servers.map(&:stack).uniq.compact
    @servers.each do |server|
      @connections[server.id] = server.directly_connected_servers_ids_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
    end
    @concentrateurs.each do |hub|
      @connections[hub.id] = hub.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
    end

    # TODO: remove when hard-coded system will be removed
    @network_types = Modele::Network::TYPES.excluding("fiber")
    @network = params[:network_type] # TODO: take from params and raise error if not good

    if @room.id == 4 || @room.id == 3
      @hub = @hubs[@network][@room.id]
      @second_room = Room.find(@room.id == 4 ? 3 : 4)
      @second_hub = @hubs[@network][@second_room.id]
    end

    # TODO: only respond to turbo frame or stream
    respond_to do |format|
      format.html
    end
  end

  def network_capacity
    @room = Room.friendly.find(params[:room_id])
    @islet = @room.islets.find(params[:id])
    @network = params[:network_type] # TODO: take from params and raise error if not good

    @bays = @islet.bays.sorted

    # TODO: only respond to turbo frame or stream
    respond_to do |format|
      format.html
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_islet
    @islet = Islet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def islet_params
    params.require(:islet).permit(:name, :room_id, :position)
  end
end
