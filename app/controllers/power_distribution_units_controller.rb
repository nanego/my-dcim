# frozen_string_literal: true

class PowerDistributionUnitsController < ApplicationController
  before_action :set_power_distribution_unit, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(PowerDistributionUnit.model_name.human, power_distribution_units_path)
  end

  # GET /power_distribution_units or /power_distribution_units.json
  def index
    authorize! @power_distribution_units = PowerDistributionUnit.includes(:type, :manufacturer, :bay, :islet, :room)
    @filter = ProcessorFilter.new(@power_distribution_units, params)
    @power_distribution_units = @filter.results
  end

  # GET /power_distribution_units/1 or /power_distribution_units/1.json
  def show; end

  # GET /power_distribution_units/new
  def new
    authorize! @power_distribution_unit = PowerDistributionUnit.new
  end

  # GET /power_distribution_units/1/edit
  def edit; end

  # POST /power_distribution_units or /power_distribution_units.json
  def create
    authorize! @power_distribution_unit = PowerDistributionUnit.new(power_distribution_unit_params)

    respond_to do |format|
      if @power_distribution_unit.save
        format.html { redirect_to_new_or_to @power_distribution_unit, notice: t(".flashes.created") }
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
        format.html { redirect_to power_distribution_unit_path(@power_distribution_unit), notice: t(".flashes.updated"), status: :see_other }
        format.json { render :show, status: :ok, location: @power_distribution_unit }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @power_distribution_unit.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /power_distribution_units/1 or /power_distribution_units/1.json
  destroy_confirmation
  def destroy
    @power_distribution_unit.destroy!

    respond_to do |format|
      format.html { redirect_back_to_param_or power_distribution_units_path, notice: t(".flashes.destroyed"), status: :see_other }
      format.json { head :no_content }
    end
  end

  def duplicate
    authorize! @original_power_distribution_unit = PowerDistributionUnit.friendly.find(params[:id].to_s.downcase)
    @power_distribution_unit = @original_power_distribution_unit.deep_dup
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_power_distribution_unit
    authorize! @power_distribution_unit = PowerDistributionUnit.friendly.find(params[:id].to_s.downcase)
  end

  # Only allow a list of trusted parameters through.
  def power_distribution_unit_params
    params.expect(power_distribution_unit: %i[type_id bay_id side orientation name slug ipmi_url serial_number comment])
  end
end
