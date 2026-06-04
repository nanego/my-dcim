# frozen_string_literal: true

class PowerDistributionUnitsController < ApplicationController
  before_action :set_power_distribution_unit, only: %i[show edit update destroy]

  # GET /power_distribution_units or /power_distribution_units.json
  def index
    @power_distribution_units = PowerDistributionUnit.all
  end

  # GET /power_distribution_units/1 or /power_distribution_units/1.json
  def show; end

  # GET /power_distribution_units/new
  def new
    @power_distribution_unit = PowerDistributionUnit.new
  end

  # GET /power_distribution_units/1/edit
  def edit; end

  # POST /power_distribution_units or /power_distribution_units.json
  def create
    @power_distribution_unit = PowerDistributionUnit.new(power_distribution_unit_params)

    respond_to do |format|
      if @power_distribution_unit.save
        format.html { redirect_to @power_distribution_unit, notice: "Power distribution unit was successfully created." }
        format.json { render :show, status: :created, location: @power_distribution_unit }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @power_distribution_unit.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /power_distribution_units/1 or /power_distribution_units/1.json
  def update
    respond_to do |format|
      if @power_distribution_unit.update(power_distribution_unit_params)
        format.html { redirect_to @power_distribution_unit, notice: "Power distribution unit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @power_distribution_unit }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @power_distribution_unit.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /power_distribution_units/1 or /power_distribution_units/1.json
  def destroy
    @power_distribution_unit.destroy!

    respond_to do |format|
      format.html { redirect_to power_distribution_units_path, notice: "Power distribution unit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_power_distribution_unit
    @power_distribution_unit = PowerDistributionUnit.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def power_distribution_unit_params
    params.expect(power_distribution_unit: %i[type_id_id bay_id_id side orientation name slug ipmi_url serial_number comment])
  end
end
