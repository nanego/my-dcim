# frozen_string_literal: true

class PowerDistributionUnitTypesController < ApplicationController
  before_action :set_power_distribution_unit_type, only: %i[show edit update destroy]

  # GET /power_distribution_unit_types or /power_distribution_unit_types.json
  def index
    authorize! @power_distribution_unit_types = PowerDistributionUnitType.all
    @filter = ProcessorFilter.new(@power_distribution_unit_types, params)
    @power_distribution_unit_types = @filter.results
  end

  # GET /power_distribution_unit_types/1 or /power_distribution_unit_types/1.json
  def show; end

  # GET /power_distribution_unit_types/new
  def new
    authorize! @power_distribution_unit_type = PowerDistributionUnitType.new
  end

  # GET /power_distribution_unit_types/1/edit
  def edit; end

  # POST /power_distribution_unit_types or /power_distribution_unit_types.json
  def create
    authorize! @power_distribution_unit_type = PowerDistributionUnitType.new(power_distribution_unit_type_params)

    respond_to do |format|
      if @power_distribution_unit_type.save
        format.html { redirect_to @power_distribution_unit_type, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @power_distribution_unit_type }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @power_distribution_unit_type.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /power_distribution_unit_types/1 or /power_distribution_unit_types/1.json
  def update
    respond_to do |format|
      if @power_distribution_unit_type.update(power_distribution_unit_type_params)
        format.html { redirect_to @power_distribution_unit_type, notice: t(".flashes.updated"), status: :see_other }
        format.json { render :show, status: :ok, location: @power_distribution_unit_type }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @power_distribution_unit_type.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /power_distribution_unit_types/1 or /power_distribution_unit_types/1.json
  destroy_confirmation
  def destroy
    @power_distribution_unit_type.destroy!

    respond_to do |format|
      format.html { redirect_to power_distribution_unit_types_path, notice: t(".flashes.destroyed"), status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_power_distribution_unit_type
    authorize! @power_distribution_unit_type = PowerDistributionUnitType.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def power_distribution_unit_type_params
    params.expect(power_distribution_unit_type: %i[manufacturer_id name current_type documentation_url meter_global meter_per_socket meter_per_circuit socket_control socket_lock ip_snmp
                                                   ip_modbus ip_ssh ip_webui rs485_modbus max_power_per_circuit])
  end
end
