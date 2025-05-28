# frozen_string_literal: true

class MovesController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :set_moves_project_step
  before_action :set_move, only: %i[show edit update destroy execute]
  before_action :load_form_data, only: %i[new edit]

  before_action do
    breadcrumb.add_step(MovesProject.model_name.human.pluralize, moves_projects_path)
    breadcrumb.add_step(@moves_project_step.moves_project, moves_project_path(@moves_project_step.moves_project))
    breadcrumb.add_step(Move.model_name.human(count: 2), moves_project_step_moves_path(@moves_project_step)) unless action_name == "index"
  end

  def index
    @moves_project = @moves_project_step.moves_project
    @moves = @moves_project_step.moves.order(created_at: :asc)
  end

  def show
    respond_to do |format|
      format.json { render :show }
    end
  end

  def new
    @move = @moves_project_step.moves.build(moveable_type: "Server")
    @move.moveable = Server.friendly.select(:id).find(params[:server_id]) if params[:server_id].present?
  end

  def edit; end

  def create
    @move = @moves_project_step.moves.build(move_params)

    @move.prev_frame_id = @move.moveable.try(:frame_id)

    if params[:move][:remove_connections] == 'Oui'
      @move.clear_connections
    end

    respond_to do |format|
      if @move.save
        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @move }
      else
        load_form_data
        format.html { render :new }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @move.update(move_params)
        @move.prev_frame_id = @move.moveable.try(:frame_id)

        if params[:move][:remove_connections] == 'Oui'
          @move.clear_connections
        end

        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @move }
      else
        load_form_data
        format.html { render :edit }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @move.executed?
      respond_to do |format|
        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), alert: t(".flashes.already_executed") }
        format.json { head :bad_request }
      end
    else
      @move.destroy

      respond_to do |format|
        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    end
  end

  def execute
    if @move.executed?
      respond_to do |format|
        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), alert: t(".flashes.already_executed") }
        format.json { head :bad_request }
      end
    else
      @move.execute!

      respond_to do |format|
        format.html { redirect_to moves_project_path(@moves_project_step.moves_project), notice: t(".flashes.executed") }
        format.json { head :no_content }
      end
    end
  end

  def load_server
    @server = Server.includes(:cards => [:card_type => :port_type], :ports => [:connection => :cable]).find(params[:server_id])
    @moved_connections = MovedConnection.per_servers([@server])
  end

  def load_frame
    @frame = Frame.find(params[:frame_id])
    @view = params[:view]
    @move = @moves_project_step.moves.build(moveable_type: 'Server')
  end

  def load_connection
    @selected_port = Port.find(params[:port_id])
    @server = @selected_port.server
    @moved_connections = MovedConnection.per_servers([@server])
    # TODO: Deal with conflicts if there is more than 1 result
    @moved_connection = @moved_connections.where(port_from_id: params[:port_id])
      .or(MovedConnection.where(port_to_id: params[:port_id])).first
    if @moved_connection.present?
      @destination_port = (@moved_connection.ports - [@selected_port]).first
    else
      @moved_connection = MovedConnection.new(port_from_id: params[:port_id],
                                              vlans: @selected_port.vlans,
                                              cablename: @selected_port.cablename || @selected_port.cable_name,
                                              color: @selected_port.color || @selected_port.cable_color)
      @destination_port = @selected_port.connection.try(:paired_connection).try(:port)
    end
  end

  def update_connection
    @port_from = Port.find(params[:moved_connection][:port_from_id])
    @port_to = Port.find(params[:moved_connection][:port_to_id])
    @servers = [@port_from.server, @port_to.try(:server)].compact

    # Current connections for all servers, necessary to refresh visible servers ports
    @moved_connections = MovedConnection.per_servers(@servers)

    @current_moved_connections = @moved_connections.where('port_from_id IN (?) OR port_to_id IN (?)',
                                                          [params[:moved_connection][:port_from_id], params[:moved_connection][:port_to_id]],
                                                          [params[:moved_connection][:port_from_id], params[:moved_connection][:port_to_id]])

    if @current_moved_connections.present?
      if @current_moved_connections.size > 1
        @current_moved_connections.delete_all
        @moved_connection = MovedConnection.new
      else
        @moved_connection = @current_moved_connections.first
      end
    else
      @moved_connection = MovedConnection.new
    end

    if params[:moved_connection][:remove_connection] == '1'
      @moved_connection.update({ vlans: "",
                                 cablename: "",
                                 color: "",
                                 port_from_id: @port_from.id,
                                 port_to_id: @port_to.try(:id) })
    else
      @moved_connection.update(moved_connection_params)
    end
    @selected_port = @moved_connection.port_from
    @destination_port = @moved_connection.port_to
  end

  private

  def set_moves_project_step
    @moves_project_step = MovesProjectStep.find(params[:moves_project_step_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_move
    @move = @moves_project_step.moves.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_params
    params.expect(move: %i[moveable_type moveable_id frame_id position prev_frame_id])
  end

  def moved_connection_params
    params.expect(moved_connection: %i[port_from_id port_to_id vlans color cablename])
  end

  def load_form_data
    get_all_servers_per_frame
    get_all_frames_per_room
  end

  def get_all_frames_per_room # rubocop:disable Naming/AccessorMethodName
    @all_frames_per_room = []
    Room.order(:position).each do |room|
      @all_frames_per_room << [room.name, room.frames.order('frames.name').collect { |v| [v.name, v.id] }]
    end
  end

  def get_all_servers_per_frame # rubocop:disable Naming/AccessorMethodName
    @all_servers_per_frame = Frame.order(:name).to_h do |frame|
      [frame.name, frame.servers.map { |v| [v.name, v.id, { data: { frame_name: frame.name } }] }]
    end
  end
end
