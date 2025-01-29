# frozen_string_literal: true

class AirConditionersController < ApplicationController
  before_action :set_air_conditioner, only: %i[show edit update destroy]

  def index
    @filter = ProcessorFilter.new(AirConditioner.joins(:room, :islet).order('rooms.position, islets.name, air_conditioners.name'), params)
    @air_conditioners = @filter.results
  end

  def show; end

  def new
    @air_conditioner = AirConditioner.new
  end

  def edit; end

  def create
    @air_conditioner = AirConditioner.new(air_conditioner_params)

    respond_to do |format|
      if @air_conditioner.save
        format.html { redirect_to @air_conditioner, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @air_conditioner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @air_conditioner.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @air_conditioner.update(air_conditioner_params)
        format.html { redirect_to @air_conditioner, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @air_conditioner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @air_conditioner.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @air_conditioner.destroy!

    respond_to do |format|
      format.html { redirect_to air_conditioners_url, notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_air_conditioner
    @air_conditioner = AirConditioner.find(params[:id])
  end

  def air_conditioner_params
    params.expect(air_conditioner: [:status, :last_service, :bay_id,
                                    :name, :air_conditioner_model_id, :position, :lift_pump,
                                    :start, :range, :setpoint, :min_setpoint,])
  end
end
