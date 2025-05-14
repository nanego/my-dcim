# frozen_string_literal: true

class MovesProjectsController < ApplicationController
  before_action :set_moves_project, only: %i[show edit update destroy]

  # GET /moves_projects or /moves_projects.json
  def index
    @moves_projects = MovesProject.all
  end

  # GET /moves_projects/1 or /moves_projects/1.json
  def show; end

  # GET /moves_projects/new
  def new
    @moves_project = MovesProject.new
  end

  # GET /moves_projects/1/edit
  def edit; end

  # POST /moves_projects or /moves_projects.json
  def create
    @moves_project = MovesProject.new(moves_project_params)

    respond_to do |format|
      if @moves_project.save
        format.html { redirect_to @moves_project, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @moves_project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @moves_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moves_projects/1 or /moves_projects/1.json
  def update
    respond_to do |format|
      if @moves_project.update(moves_project_params)
        format.html { redirect_to @moves_project, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @moves_project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @moves_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves_projects/1 or /moves_projects/1.json
  def destroy
    @moves_project.destroy!

    respond_to do |format|
      format.html { redirect_to moves_projects_path, status: :see_other, notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_moves_project
    @moves_project = MovesProject.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def moves_project_params
    params.expect(moves_project: [:name])
  end
end
