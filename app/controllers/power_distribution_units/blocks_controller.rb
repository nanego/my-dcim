# frozen_string_literal: true

module PowerDistributionUnits
  class BlocksController < ApplicationController
    before_action :set_power_distribution_unit, only: %i[edit update]
    before_action do
      breadcrumb.add_step(t("power_distribution_units.index.title"), power_distribution_units_path)
      breadcrumb.add_step(@power_distribution_unit, power_distribution_unit_path(@power_distribution_unit))
    end

    def edit; end

    def update
      respond_to do |format|
        if @power_distribution_unit.update(power_distribution_unit_params)
          format.html { redirect_to power_distribution_unit_path(@power_distribution_unit), notice: t(".flashes.updated"), status: :see_other }
          format.json { render :show, status: :ok, location: power_distribution_unit_path(@power_distribution_unit) }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @power_distribution_unit.errors, status: :unprocessable_content }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_power_distribution_unit
      authorize! @power_distribution_unit = PowerDistributionUnit.friendly.find(params[:power_distribution_unit_id].to_s.downcase)
    end

    # Only allow a list of trusted parameters through.
    def power_distribution_unit_params
      params.expect(
        power_distribution_unit: [
          {
            blocks_attributes: [[
              :id, :position, :_destroy,
              { sockets_attributes: [%i[id number port_type_id circuit_id _destroy]] },
            ]],
            cards_attributes: [%i[id _destroy card_type_id name first_position orientation]],
          },
        ],
      )
    end
  end
end
