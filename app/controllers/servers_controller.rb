# frozen_string_literal: true

class ServersController < ApplicationController # rubocop:disable Metrics/ClassLength
  include ServersHelper
  include RoomsHelper
  include ColumnsPreferences

  DEFAULT_COLUMNS = %w[name numero modele_category_id islet_id bay_id network_types position].freeze
  AVAILABLE_COLUMNS = %w[name numero modele_category_id islet_id bay_id network_types position gestion_id frame_id cluster_id
                         stack_id domaine_id modele_id u slug side color comment critique].freeze

  columns_preferences_with model: Server, default: DEFAULT_COLUMNS, available: AVAILABLE_COLUMNS, only: %i[index export]

  before_action :set_server, only: %i[show edit update destroy destroy_connections export_cables]
  before_action :set_cables, only: %i[export_cables]
  before_action except: %i[index export_cables export destroy_connections] do
    breadcrumb.add_step(Server.model_name.human, servers_path)
  end

  def index
    # Let server knows that now name is not used anymore for research
    if params[:name].present?
      params[:q] = params[:name]

      logger.warn("DEPRECATION WARNING: Search with 'name' is now deprecated. Use 'q' instead.")
    end

    authorize! @servers = scoped_servers.no_pdus
      .includes(frame: { bay: { islet: :room } }, modele: :category)
      .references(frame: { bay: { islet: :room } }, modele: :category)
      .order(:name)

    @filter = ProcessorFilter.new(@servers, params)
    @servers = @filter.results

    respond_to do |format|
      format.json
      format.html { @pagy, @servers = pagy(@servers) }
    end
  end

  def show; end

  def new
    authorize! @server = Server.new
    @server.assign_attributes(server_params) if params[:server]
  end

  def edit; end

  def create
    authorize! @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to_new_or_to(@server, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @server.update(server_params)
        format.html { redirect_to @server, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit }
        format.json { render json: @server.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @server.destroy
        format.html { redirect_to servers_path(search_params), notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      else
        format.html { redirect_to servers_path(search_params), alert: t(".flashes.not_destroyed") }
        format.json { head :bad_request }
      end
    end
  end

  def duplicate
    authorize! @original_server = scoped_servers.friendly.find(params[:id].to_s.downcase)
    @server = @original_server.deep_dup
  end

  def destroy_connections
    if @server.destroy_connections!
      flash[:notice] = t(".flashes.connections_destroyed")
    else
      flash[:alert] = t(".flashes.connections_not_destroyed")
    end

    redirect_to server_path(@server)
  end

  def sort
    authorize!

    room = Room.find_by_name(params[:room]) unless params[:room].include?("non ")
    frame = room.frames.where("islets.name = ? AND frames.name = ?", params[:islet], params[:frame]).first
    positions = params[:positions].split(",")

    params[:server].each_with_index do |id, index|
      if positions[index].present?
        server = scoped_servers.find_by_id(id)
        new_params = { position: positions[index] }
        new_params[:frame_id] = frame.id if frame.present?

        server.update(new_params)
      end
    end if params[:server].present?
    head :ok # render empty body, status only
  end

  def import_csv
    authorize!
  end

  def import
    authorize!

    value = ImportEquipmentByCsv.call(file: params[:import][:file],
                                      room_id: params[:import][:room_id])
    if value.is_a?(Frame)
      redirect_to frame_path(value), notice: t(".flashes.imported")
    else
      @import_error = value
      render :import_csv
    end
  end

  def export
    authorize! @servers = scoped_servers
      .includes(frame: { bay: { islet: :room } }, modele: :category)
      .references(frame: { bay: { islet: :room } }, modele: :category)
      .order(:name)

    @filter = ProcessorFilter.new(@servers, params)
    @servers = @filter.results
    _, @servers = pagy(@servers) if params[:page]

    exporter = ServerExporter.new(@servers, @columns_preferences.preferred)

    respond_to do |format|
      format.csv { send_data exporter.to_csv, filename: "#{DateTime.now.strftime("%Y-%m-%d-%H-%M-%S")}-servers.csv" }
    end
  end

  def export_cables
    @servers_per_frames = {}
    sort_order = frames_sort_order(:back, @server.bay.lane)

    Frames::IncludingServersQuery.call(@server.bay.frames, "frames.position #{sort_order}").each do |frame|
      room = @server.bay.islet.room_id
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

    render layout: "pdf"
  end

  private

  def scoped_servers
    authorized_scope(Server.no_pdus)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_server
    authorize! @server = scoped_servers.friendly_find_by_numero_or_name(params[:id])
  end

  def set_cables
    @cables = @server.cables.includes(ports: { server: { modele: :category } })
    alim_cables = @cables.joins(:port_types).where(port_types: PortType.where(name: "ALIM")).uniq
    other_cables = @cables.select { |c| alim_cables.exclude?(c) }

    @cables = decorate(other_cables + alim_cables)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def server_params
    params.expect(
      server: [
        :photo, :stack_id, :comment, :cluster_id, :position, :frame_id, :gestion_id, :name, :modele_id,
        :numero, :critique, :domaine_id,
        :frame, # TODO: Check if it should be removed or if it's used somewhere
        { network_types: [] },
        { cards_attributes: [%i[composant_id card_type_id twin_card_id orientation name first_position _destroy id]] },
        { documents_attributes: [%i[document id _destroy]] },
      ],
    )
  end

  def search_params
    params.permit(:sort, :sort_by, :page, :per_page, :q,
                  network_types: [], bay_ids: [], islet_ids: [], room_ids: [], frame_ids: [], cluster_ids: [],
                  gestion_ids: [], domaine_ids: [], modele_ids: [], stack_ids: [], category_ids: [])
  end
end
