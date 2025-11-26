# frozen_string_literal: true

class GestionsController < ApplicationController
  before_action :set_gestion, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Gestion.model_name.human.pluralize, gestions_path)
  end

  # GET /gestions
  # GET /gestions.json
  def index
    authorize! @gestions = sorted(Gestion.all)
  end

  # GET /gestions/1
  # GET /gestions/1.json
  def show; end

  # GET /gestions/new
  def new
    authorize! @gestion = Gestion.new
  end

  # GET /gestions/1/edit
  def edit; end

  # POST /gestions
  # POST /gestions.json
  def create
    authorize! @gestion = Gestion.new(gestion_params)

    respond_to do |format|
      if @gestion.save
        format.html { redirect_to_new_or_to(@gestion, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @gestion }
      else
        format.html { render :new }
        format.json { render json: @gestion.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /gestions/1
  # PATCH/PUT /gestions/1.json
  def update
    respond_to do |format|
      if @gestion.update(gestion_params)
        format.html { redirect_to @gestion, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @gestion }
      else
        format.html { render :edit }
        format.json { render json: @gestion.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /gestions/1
  # DELETE /gestions/1.json
  destroy_confirmation
  def destroy
    if @gestion.destroy
      respond_to do |format|
        format.html { redirect_to gestions_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to gestions_url, alert: @gestion.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gestion
    authorize! @gestion = Gestion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def gestion_params
    params.expect(gestion: %i[name description])
  end
end
