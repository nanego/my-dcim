# frozen_string_literal: true

class ArchitecturesController < ApplicationController
  before_action :set_architecture, only: [:show, :edit, :update, :destroy]

  # GET /architectures
  # GET /architectures.json
  def index
    @architectures = sorted Architecture.all
  end

  # GET /architectures/1
  # GET /architectures/1.json
  def show; end

  # GET /architectures/new
  def new
    @architecture = Architecture.new
  end

  # GET /architectures/1/edit
  def edit; end

  # POST /architectures
  # POST /architectures.json
  def create
    @architecture = Architecture.new(architecture_params)

    respond_to do |format|
      if @architecture.save
        format.html { redirect_to @architecture, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @architecture }
      else
        format.html { render :new }
        format.json { render json: @architecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /architectures/1
  # PATCH/PUT /architectures/1.json
  def update
    respond_to do |format|
      if @architecture.update(architecture_params)
        format.html { redirect_to @architecture, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @architecture }
      else
        format.html { render :edit }
        format.json { render json: @architecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /architectures/1
  # DELETE /architectures/1.json
  def destroy
    if @architecture.destroy
      respond_to do |format|
        format.html { redirect_to architectures_url, notice: t(".destroy.flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to architectures_url, alert: @architecture.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_architecture
    @architecture = Architecture.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def architecture_params
    params.require(:architecture).permit(:name, :description)
  end
end
