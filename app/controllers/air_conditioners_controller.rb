# frozen_string_literal: true

class AirConditionersController < ApplicationController
  before_action :set_air_conditioner, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(AirConditioner.model_name.human, air_conditioners_path)
  end

  def index
    @air_conditioners = AirConditioner.joins(bay: { islet: :room })
      .order("rooms.position, islets.name, air_conditioners.name")

    @filter = ProcessorFilter.new(@air_conditioners, params)
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
        format.html { redirect_to_new_or_to(@air_conditioner, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @air_conditioner }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @air_conditioner.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @air_conditioner.update(air_conditioner_params)
        format.html { redirect_to @air_conditioner, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @air_conditioner }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @air_conditioner.errors, status: :unprocessable_content }
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
    params.expect(air_conditioner: %i[status last_service bay_id
                                      name air_conditioner_model_id position lift_pump
                                      start range setpoint min_setpoint])
  end
end
