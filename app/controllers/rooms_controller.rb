# frozen_string_literal: true

class RoomsController < ApplicationController
  include ServersHelper
  include RoomsHelper

  before_action :set_room, only: %i[show edit update destroy]
  before_action except: %i[index overview filtered_overview] do
    breadcrumb.add_step(Room.model_name.human.pluralize, rooms_path)
  end

  def index
    @rooms = Room.joins(:site).order("sites.position asc, rooms.position asc, rooms.name asc")
    @filter = ProcessorFilter.new(@rooms, params)
    @rooms = @filter.results
  end

  def show
    @sites = Site.joins(:rooms).includes(:rooms => [:bays => [:bay_type]]).order(:position).distinct
    @islet = Islet.find_by(name: params[:islet], room_id: @room.id) if params[:islet].present?

    @air_conditioners = AirConditioner.all

    respond_to do |format|
      format.html
      format.json
    end
  end

  def overview
    @sites = Site.order(:position).joins(:rooms => :frames).distinct

    if params[:cluster_id].present? ||
       params[:gestion_id].present? ||
       params[:modele_id].present?
      @frames = Frame.preload(:servers => [:gestion, :cluster, { :modele => :category, :card_types => :port_type, :cards => [:composant, { :ports => [:connection => :cable] }] }])
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
        format.html { redirect_to_new_or_to(@room, notice: t(".flashes.created")) }
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
        format.html do
          if params[:infrastructure]
            redirect_back fallback_location: root_path, notice: t(".flashes.updated")
          else
            redirect_to @room, notice: t(".flashes.updated")
          end
        end
        format.json { render :show, status: :ok, location: @room }
      else
        format.html do
          if params[:infrastructure]
            redirect_back fallback_location: root_path, alert: t(".flashes.failure")
          else
            render :edit
          end
        end
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @room.destroy
      respond_to do |format|
        format.html { redirect_to rooms_url, notice: t(".flashes.destroyed") }
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
    params.expect(
      room: [
        :name, :description, :display_on_home_page, :position, :status, :site_id, :surface_area, :access_control,
        { network_cluster_ids: [] },
      ]
    )
  end
end
