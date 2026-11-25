# frozen_string_literal: true

module PowerDistributionUnitTypes
  class BlocksController < ApplicationController
    before_action :set_power_distribution_unit_type, only: %i[edit update]
    before_action do
      breadcrumb.add_step(PowerDistributionUnitType.model_name.human(count: 2), power_distribution_unit_types_path)
      breadcrumb.add_step(@power_distribution_unit_type, power_distribution_unit_type_path(@power_distribution_unit_type))
    end

    def edit; end

    def update
      respond_to do |format|
        if @power_distribution_unit_type.update(power_distribution_unit_type_params)
          format.html { redirect_to power_distribution_unit_type_path(@power_distribution_unit_type), notice: t(".flashes.updated"), status: :see_other }
          format.json { render :show, status: :ok, location: power_distribution_unit_type_path(@power_distribution_unit_type) }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @power_distribution_unit_type.errors, status: :unprocessable_content }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_power_distribution_unit_type
      authorize! @power_distribution_unit_type = PowerDistributionUnitType.find(params.expect(:power_distribution_unit_type_id))
    end

    # Only allow a list of trusted parameters through.
    def power_distribution_unit_type_params
      params.expect(
        power_distribution_unit_type: [
          {
            blocks_attributes: [[
              :id, :position, :_destroy,
              { sockets_attributes: [%i[id position name port_type_id circuit_id _destroy]] },
            ]],
            cards_attributes: [%i[id _destroy card_type_id name first_position orientation]],
          },
        ],
      )
    end
  end
end
