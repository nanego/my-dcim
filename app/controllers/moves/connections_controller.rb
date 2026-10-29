# frozen_string_literal: true

module Moves
  class ConnectionsController < ApplicationController
    before_action :set_move
    before_action :set_move_connection, only: %i[edit update destroy]
    before_action :set_move_connections, only: %i[new create edit update update_destination_server]
    before_action :set_all_servers_per_frames, only: %i[new create edit update]

    before_action do
      breadcrumb.add_step(MovesProject.model_name.human.pluralize, moves_projects_path)
      breadcrumb.add_step(@move.moves_project, moves_project_path(@move.moves_project))
      breadcrumb.add_step(@move.step, moves_project_step_moves_path(@move.step))
    end

    before_action except: %i[index] do
      breadcrumb.add_step(@move.decorated.display_name, move_connections_path(@move))
    end

    def index
      authorize! @move_connections = scoped_move_connections
    end

    def new
      if (move_connection = Move::Connection.where(move: @move).find_by(port_from_id: params[:port_from_id]))
        redirect_to edit_move_connection_path(@move, move_connection)
      end

      authorize! @move_connection = scoped_move_connections.new
      @move_connection.port_from = port = Port.find(params[:port_from_id])
      @move_connection.vlans = port.vlans

      if (connection = port.connection.presence)
        @move_connection.port_to = connection.paired_connection&.port
        @move_connection.cable_name = connection.cable.name
        @move_connection.cable_color = connection.cable.color
      end
    end

    def edit; end

    def create
      authorize! @move_connection = scoped_move_connections.new(move_connection_params)

      respond_to do |format|
        if @move_connection.save
          format.html { redirect_to_new_or_to(moves_project_step_move_path(@move.step, @move), notice: t(".flashes.created")) }
          format.json { render :show, status: :created, location: move_connections_path(@move) }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @move_connection.errors, status: :unprocessable_content }
        end
      end
    end

    def update
      respond_to do |format|
        if @move_connection.update(move_connection_params)
          format.html { redirect_to moves_project_step_move_path(@move.step, @move), notice: t(".flashes.updated") }
          format.json { render :show, status: :ok, location: move_connections_path(@move) }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @move_connection.errors, status: :unprocessable_content }
        end
      end
    end

    destroy_confirmation
    def destroy
      @move_connection.destroy
      respond_to do |format|
        format.html { redirect_back_to_param_or moves_project_step_move_path(@move.step, @move), notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    end

    def update_destination_server
      authorize!

      @server = Server.find_by(id: params[:server_id])

      return unless @server

      @server.create_missing_ports
      @server.reload
    end

    private

    def set_move
      authorize! @move = Move.find(params[:move_id])
    end

    def set_move_connections
      @move_connections = @move.step.moves_planned_at_current_step.map(&:connections).flatten
    end

    def scoped_move_connections
      @move.connections
    end

    def set_move_connection
      authorize! @move_connection = scoped_move_connections.find(params[:id])
    end

    def set_all_servers_per_frames
      @all_servers_per_frames = Frame.order(:name).to_h do |frame|
        [
          frame.name,
          @move.step.servers_at_current_step_for(frame).map do |v|
            [v.name, v.id]
          end,
        ]
      end
    end

    def move_connection_params
      params.expect(move_connection: %i[cable_name cable_color vlans port_from_id port_to_id])
    end
  end
end
