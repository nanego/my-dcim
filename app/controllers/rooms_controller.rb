# frozen_string_literal: true

class RoomsController < ApplicationController # rubocop:disable Metrics/ClassLength
  include ServersHelper
  include RoomsHelper

  before_action :set_room, only: %i[show edit update destroy islet]

  def index
    @filter = ProcessorFilter.new(Room.joins(:site).order('sites.position asc, rooms.position asc, rooms.name asc'), params)
    @rooms = @filter.results
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

    @air_conditioners = AirConditioner.all

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
