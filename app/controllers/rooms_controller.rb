class RoomsController < ApplicationController
  include ServersHelper

  before_action :set_room, only: [:show, :edit, :update, :destroy, :islet]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.order(:position)
  end

  def show
    @servers_per_frames = {}
    @sums = {}
    @room.frames.includes(:servers, :islet, :bay => :frames).order('islets.name, bays.lane, bays.position, frames.position').each do |frame|
      servers = frame.servers.includes(:gestion, :cluster, :modele => :category, :cards => :port_type, :cards_servers => [:composant, :ports])
      servers.each do |s|
        islet = frame.bay.islet.name
        @servers_per_frames[islet] ||= {}
        @servers_per_frames[islet][frame.bay.lane] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] ||= []
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] << s
      end
      @sums.merge!(calculate_ports_sums(frame, servers))
    end

    respond_to do |format|
      format.html do
        render 'rooms/show'
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

  def islet
    islet = params[:islet]
    @servers_per_frames = {}
    @sums = {}
    @room.frames.includes(:servers, :islet, :bay).where('islets.name = ?', islet).each do |frame|
      servers = frame.servers.includes(:gestion, :modele => :category, :cards => :port_type, :cards_servers => :composant)
      servers.each do |s|
        islet = frame.bay.islet.name
        @servers_per_frames[islet] ||= {}
        @servers_per_frames[islet][frame.bay.lane] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay] ||= {}
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] ||= []
        @servers_per_frames[islet][frame.bay.lane][frame.bay][frame] << s
      end
      @sums.merge!(calculate_ports_sums(frame, servers))
    end

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

  def overview
    @rooms = Room.order(:position).joins(:frames).uniq

    if params[:cluster_id].present? || params[:gestion_id].present?
      @frames = Frame.preload(:servers => [:gestion, :cluster, :modele => :category, :cards => :port_type, :cards_servers => [:composant, :ports] ])
                    .includes(:bay => [:frames, {:islet => :room}])
                    .order('rooms.position asc, islets.name asc, bays.position asc, frames.position asc')
      # @sums = {}
      # @frames.each do |frame|
      #   @sums.merge!(calculate_ports_sums(frame, frame.servers))
      # end
      @current_filters = ''
      if params[:cluster_id].present?
        @frames = @frames.joins(:servers).where('servers.cluster_id = ? ', params[:cluster_id])
        @filtered_servers = Server.where('servers.cluster_id = ? ', params[:cluster_id])
        @current_filters << "Cluster #{Cluster.find_by_id(params[:cluster_id])} "
      elsif params[:gestion_id].present?
        @frames = @frames.joins(:servers).where('servers.gestion_id = ? ', params[:gestion_id])
        @filtered_servers = Server.where('servers.gestion_id = ? ', params[:gestion_id])
        @current_filters << "Gestionnaire #{Gestion.find_by_id(params[:gestion_id])} "
      end
      render :filtered_overview
    end
  end

  def filtered_overview
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
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

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
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

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.friendly.find(params[:id].to_s.downcase)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:title, :description, :published, :display_on_home_page, :position, :site_id)
    end
end
