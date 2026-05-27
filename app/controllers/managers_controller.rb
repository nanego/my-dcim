# frozen_string_literal: true

class ManagersController < ApplicationController
  before_action :set_manager, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Manager.model_name.human.pluralize, managers_path)
  end

  # GET /managers
  # GET /managers.json
  def index
    @filter = ProcessorFilter.new(Manager.all, params)
    authorize! @managers = @filter.results
  end

  # GET /managers/1
  # GET /managers/1.json
  def show; end

  # GET /managers/new
  def new
    authorize! @manager = Manager.new
  end

  # GET /managers/1/edit
  def edit; end

  # POST /managers
  # POST /managers.json
  def create
    authorize! @manager = Manager.new(manager_params)

    respond_to do |format|
      if @manager.save
        format.html { redirect_to_new_or_to(@manager, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @manager }
      else
        format.html { render :new }
        format.json { render json: @manager.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /managers/1
  # PATCH/PUT /managers/1.json
  def update
    respond_to do |format|
      if @manager.update(manager_params)
        format.html { redirect_to @manager, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @manager }
      else
        format.html { render :edit }
        format.json { render json: @manager.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  destroy_confirmation
  def destroy
    if @manager.destroy
      respond_to do |format|
        format.html { redirect_back_to_param_or managers_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back_to_param_or managers_url, alert: @manager.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_manager
    authorize! @manager = Manager.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manager_params
    params.expect(manager: %i[name description])
  end
end
