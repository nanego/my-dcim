# frozen_string_literal: true

class MemoryComponentsController < ApplicationController
  before_action :set_memory_component, only: [:show, :edit, :update, :destroy]

  # GET /memory_components
  # GET /memory_components.json
  def index
    @memory_components = MemoryComponent.all
  end

  # GET /memory_components/1
  # GET /memory_components/1.json
  def show; end

  # GET /memory_components/new
  def new
    @memory_component = MemoryComponent.new
  end

  # GET /memory_components/1/edit
  def edit; end

  # POST /memory_components
  # POST /memory_components.json
  def create
    @memory_component = MemoryComponent.new(memory_component_params)

    respond_to do |format|
      if @memory_component.save
        format.html { redirect_to @memory_component.server, notice: 'Memory component was successfully created.' }
        format.json { render :show, status: :created, location: @memory_component }
      else
        format.html { render :new }
        format.json { render json: @memory_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memory_components/1
  # PATCH/PUT /memory_components/1.json
  def update
    respond_to do |format|
      if @memory_component.update(memory_component_params)
        format.html { redirect_to @memory_component.server, notice: 'Memory component was successfully updated.' }
        format.json { render :show, status: :ok, location: @memory_component }
      else
        format.html { render :edit }
        format.json { render json: @memory_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memory_components/1
  # DELETE /memory_components/1.json
  def destroy
    @memory_component.destroy
    respond_to do |format|
      format.html { redirect_to memory_components_url, notice: 'Memory component a bien été supprimé.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_memory_component
      @memory_component = MemoryComponent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memory_component_params
      params.require(:memory_component).permit(:server_id, :memory_type_id, :quantity)
    end
end
