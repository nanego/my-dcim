# frozen_string_literal: true

module Moves
  class ConnectionsController < ApplicationController
    before_action :set_move
    before_action :set_move_connection, only: %i[edit update destroy]
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
      authorize! @move_connection = scoped_move_connections.new
      @move_connection.port_from = Port.find(params[:port_from_id])
    end

    def edit; end

    def create
      authorize! @move_connection = scoped_move_connections.new(move_connection_params)

      respond_to do |format|
        if @move_connection.save
          format.html { redirect_to_new_or_to(move_connections_path(@move), notice: t(".flashes.created")) }
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
          format.html { redirect_to move_connections_path(@move), notice: t(".flashes.updated") }
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
        format.html { redirect_back_to_param_or move_connections_path(@move), notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    end

    private

    def set_move
      authorize! @move = Move.find(params[:move_id])
    end

    def scoped_move_connections
      @move.move_connections
    end

    def set_move_connection
      authorize! @move_connection = scoped_move_connections.find(params[:id])
    end

    def move_connection_params
      params.expect(move_connection: %i[cable_name cable_color vlans port_from_id port_to_id])
    end
  end
end
