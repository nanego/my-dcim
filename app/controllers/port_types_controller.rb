# frozen_string_literal: true

class PortTypesController < ApplicationController
  before_action :set_port_type, only: [:show, :edit, :update, :destroy]

  def index
    @port_types = sorted PortType.order('lower(name)')
  end

  def show; end

  def new
    @port_type = PortType.new
  end

  def edit; end

  def create
    @port_type = PortType.new(port_type_params)

    respond_to do |format|
      if @port_type.save
        format.html { redirect_to @port_type, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @port_type }
      else
        format.html { render :new }
        format.json { render json: @port_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @port_type.update(port_type_params)
        format.html { redirect_to @port_type, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @port_type }
      else
        format.html { render :edit }
        format.json { render json: @port_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @port_type.destroy
    respond_to do |format|
      format.html { redirect_to port_types_path, notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_port_type
    @port_type = PortType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def port_type_params
    params.require(:port_type).permit(:name, :power)
  end
end
