# frozen_string_literal: true

class BaysController < ApplicationController
  include RoomsHelper

  before_action :set_bay, only: %i[edit update destroy show]

  def index
    @bays   = Bay.joins(islet: :room).order('rooms.position, islets.name, bays.lane, bays.position')
    @filter = ProcessorFilter.new(@bays, params)
    @bays = @filter.results
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @bay = Bay.new
  end

  def edit; end

  def create
    @bay = Bay.new(bay_params)

    respond_to do |format|
      if @bay.save
        format.html { redirect_to @bay, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @bay }
      else
        format.html { render :new }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bay.update(bay_params)
        format.html { redirect_to @bay, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @bay }
      else
        format.html { render :edit }
        format.json { render json: @bay.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @bay.destroy
      respond_to do |format|
        format.html { redirect_to bays_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to bays_url, alert: @bay.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bay
    @bay = Bay.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bay_params
    params.expect(bay: %i[name lane position width depth access_control bay_type_id islet_id manufacturer_id])
  end
end
