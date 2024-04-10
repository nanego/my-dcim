# frozen_string_literal: true

class RoomsController < ApplicationController
  include ServersHelper
  include RoomsHelper

  before_action :set_room, only: %i[show edit update destroy islet]

  def index
    @filter = Filter.new(Room.all, params)
    @rooms = sorted @filter.results.joins(:site).order('sites.position asc, rooms.position asc, rooms.name asc')
  end

  def show
    @sites = Site.joins(:rooms).includes(:rooms => [:bays => [:bay_type]]).order(:position).distinct
    @islet = Islet.find_by(name: params[:islet], room_id: @room.id) if params[:islet].present?
    frames = Frames::IncludingServersQuery.call
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
      format.html
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

  # TODO: Remove this action when possible
  def islet
    @islet = Islet.find_by(name: params[:islet], room_id: @room.id)
    frames = Frames::IncludingServersQuery.call(@room.frames.where('islets.name = ?', @islet.name), 'islets.name, bays.lane')
    @servers_per_frames = {}

    sorted_frames_per_islet(frames, params[:view]).each do |frame|
      islet = frame.bay.islet.name
      @servers_per_frames[islet] ||= {}
      @servers_per_frames[islet][frame.bay.lane] ||= {}
      @servers_per_frames[islet][frame.bay.lane][frame.bay] ||= {}
      @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] ||= []
      frame.servers.each do |s|
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] << s
      end
    end

    respond_to do |format|
      format.html do
        render :show
      end
      format.pdf do
        render template: "rooms/show",
               show_as_html: params[:debug].present?,
               pdf: 'frame',
               zoom: 0.75
      end
      format.txt { send_data Frame.to_txt(@servers_per_frames, params[:bg]) }
    end
  end

  def overview
    @sites = Site.order(:position).joins(:rooms => :frames).distinct

    if params[:cluster_id].present? ||
       params[:gestion_id].present? ||
       params[:modele_id].present?
      @frames = Frame.preload(:servers => [:gestion, :cluster, :modele => :category, :card_types => :port_type, :cards => [:composant, :ports => [:connection => :cable]]])
        .includes(:bay => [:frames, { :islet => :room }])
        .order('rooms.position asc, islets.name asc, bays.position asc, frames.position asc')
      @current_filters = []
      if params[:cluster_id].present?
        @frames = @frames.joins(:materials).where('servers.cluster_id = ? ', params[:cluster_id])
        @filtered_servers = Server.where('servers.cluster_id = ? ', params[:cluster_id])
        @current_filters << "Cluster #{Cluster.find_by_id(params[:cluster_id])} "
      elsif params[:gestion_id].present?
        @frames = @frames.joins(:materials).where('servers.gestion_id = ? ', params[:gestion_id])
        @filtered_servers = Server.where('servers.gestion_id = ? ', params[:gestion_id])
        @current_filters << "Gestionnaire #{Gestion.find_by_id(params[:gestion_id])} "
      elsif params[:modele_id].present?
        @frames = @frames.joins(:materials).where('servers.modele_id = ? ', params[:modele_id])
        @filtered_servers = Server.where('servers.modele_id = ? ', params[:modele_id])
        @current_filters << "Modèle #{Modele.find_by_id(params[:modele_id])} "
      end
      render :filtered_overview
    end
  end

  def infrastructure
    @sites = Site.joins(:rooms).includes(:rooms => [:islets => [:bays => :frames]]).order(:position).distinct
    @room = @sites.first.rooms.order(:position).first
    @islet = @room.islets.first

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

    # puts "@@@connections : #{@connections.inspect}"
  end

  def capacity
    @sites = Site.joins(:rooms).includes(:rooms => [:islets => [:bays => :frames]]).order(:position).distinct
    @room = @sites.first.rooms.order(:position).first
    @islet = @room.islets.first
    @servers_last_update_time = Server.maximum(:updated_at).to_s
    @ports_last_update_time = Port.maximum(:updated_at).to_s
  end

  def filtered_overview; end

  def new
    @room = Room.new
  end

  def edit; end

  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_path, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to rooms_path, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @room.destroy
      respond_to do |format|
        format.html { redirect_to rooms_url, notice: 'Room a bien été supprimé.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to rooms_url, alert: @room.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.friendly.find(params[:id].to_s.downcase)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(:name, :description, :display_on_home_page, :position, :site_id)
  end
end
