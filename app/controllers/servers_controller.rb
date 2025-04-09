# frozen_string_literal: true

class ServersController < ApplicationController
  include ServersHelper

  DEFAULT_COLUMNS = %w[name numero modele.category islet bay network_types].freeze
  AVAILABLE_COLUMNS = %w[name numero modele.category islet bay network_types domaine gestion frame cluster stack comment critique].freeze

  before_action :set_server, only: %i[show edit update destroy destroy_connections]

  def index
    # Let server knows that now name is not used anymore for research
    if params[:name].present?
      params[:q] = params[:name]

      logger.warn("DEPRECATION WARNING: Search with 'name' is now deprecated. Use 'q' instead.")
    end

    @servers = Server.no_pdus
      .includes(@displayed_associations_columns, frame: { bay: { islet: :room } }, modele: :category)
      .references(@displayed_associations_columns, frame: { bay: { islet: :room } }, modele: :category)
      .order(:name)

    @filter = ProcessorFilter.new(@servers, params)
    @servers, @displayed_columns = Columns.new(@servers, search_params, DEFAULT_COLUMNS, AVAILABLE_COLUMNS, self).perform
    @servers = @filter.results

    respond_to do |format|
      format.json
      format.html { @pagy, @servers = pagy(@servers) }
    end
  end

  def show; end

  def new
    @server = Server.new
  end

  def edit; end

  def create
    @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
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
        format.json { render json: @server.errors, status: :unprocessable_entity }
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

  def grid
    @servers = ServersGrid.new(params[:servers_grid])
  end

  def sort
    room = Room.find_by_name(params[:room]) unless params[:room].include?('non ')
    frame = room.frames.where('islets.name = ? AND frames.name = ?', params[:islet], params[:frame]).first
    positions = params[:positions].split(',')

    params[:server].each_with_index do |id, index|
      if positions[index].present?
        server = Server.find_by_id(id)
        new_params = { position: positions[index] }
        new_params[:frame_id] = frame.id if frame.present?

        server.update(new_params)
      end
    end if params[:server].present?
    head :ok # render empty body, status only
  end

  def import_csv; end

  def import
    value = ImportEquipmentByCsv.call(file: params[:import][:file],
                                      room_id: params[:import][:room_id])
    if value.is_a?(Frame)
      redirect_to frame_path(value), notice: t(".flashes.imported")
    else
      @import_error = value
      render :import_csv
    end
  end

  def duplicate
    @original_server = Server.friendly.find(params[:id].to_s.downcase)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_server
    @server = Server.friendly_find_by_numero_or_name(params[:id])
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
      ]
    )
  end

  def search_params
    params.permit(:sort, :sort_by, :page, :per_page, :q,
                  network_types: [], bay_ids: [], islet_ids: [], room_ids: [], frame_ids: [], cluster_ids: [],
                  gestion_ids: [], domaine_ids: [], modele_ids: [], stack_ids: [], category_ids: [], columns: [])
  end

  def track_frame_and_position(old_values, new_values)
    new_params = {}
    new_params['frame'] = [Frame.find_by_id(old_values['frame_id']).to_s, Frame.find_by_id(new_values['frame_id']).to_s]
    new_params['position'] = [old_values['position'].to_s, new_values['position'].to_s]
    # %W"position frame_id".each do |attribute|
    #  new_params[attribute] = [old_values[attribute].to_s, new_values[attribute]]
    # end
    new_params
  end
end
