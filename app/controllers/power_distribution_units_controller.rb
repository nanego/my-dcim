# frozen_string_literal: true

class PowerDistributionUnitsController < ApplicationController
  before_action :set_pdu, only: %i[show edit update destroy]
  before_action except: %i[index] do
    # TODO: prefer use ActiveRecord translation of Modele name
    breadcrumb.add_step(t("power_distribution_units.index.title"), power_distribution_units_path)
  end

  def index
    @pdus = scoped_power_distribution_units.includes(:frame, :room, :islet, bay: :frames, modele: :category)
      .references(:room, :islet, :bay, modele: :category)
      .order(:name)
    authorize! @pdus, with: PowerDistributionUnitPolicy

    @filter = ProcessorFilter.new(@pdus, params, with: PowerDistributionUnitsProcessor)
    @pdus = @filter.results

    respond_to do |format|
      format.json
      format.html { @pagy, @pdus = pagy(@pdus) }
    end
  end

  def show; end

  def new
    @pdu = Server.new
    authorize! @pdu, with: PowerDistributionUnitPolicy
  end

  def edit; end

  def create
    @pdu = Server.new(pdu_params)
    authorize! @pdu, with: PowerDistributionUnitPolicy

    respond_to do |format|
      if @pdu.save
        format.html { redirect_to_new_or_to(power_distribution_unit_path(@pdu), notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @pdu }
      else
        format.html { render :new }
        format.json { render json: @pdu.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    @pdu.assign_attributes(pdu_params)

    if params[:preview]
      respond_to do |format|
        format.turbo_stream { render :preview, status: :unprocessable_content }
      end
    else
      respond_to do |format|
        if @pdu.save
          format.html { redirect_to power_distribution_unit_path(@pdu), notice: t(".flashes.updated") }
          format.json { render :show, status: :ok, location: @pdu }
        else
          format.html { render :edit }
          format.json { render json: @pdu.errors, status: :unprocessable_content }
        end
      end
    end
  end

  destroy_confirmation
  def destroy
    respond_to do |format|
      if @pdu.destroy
        format.html { redirect_to power_distribution_units_path(search_params), notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      else
        format.html { redirect_to power_distribution_units_path(search_params), alert: t(".flashes.not_destroyed") }
        format.json { head :bad_request }
      end
    end
  end

  def duplicate
    @original_pdu = scoped_power_distribution_units.friendly.find(params[:id].to_s.downcase)
    authorize! @original_pdu, with: PowerDistributionUnitPolicy

    @pdu = @original_pdu.deep_dup
  end

  private

  def scoped_power_distribution_units
    Server.only_pdus
  end

  def set_pdu
    @pdu = scoped_power_distribution_units.friendly_find_by_numero_or_name(params[:id])
    authorize! @pdu, with: PowerDistributionUnitPolicy
  end

  def pdu_params
    params.expect(
      power_distribution_unit: [
        :photo, :comment, :position, :frame_id, :gestion_id, :name, :modele_id, :numero, :critique, :domaine_id,
        :frame, # TODO: Check if it should be removed or if it's used somewhere
        { cards_attributes: [%i[composant_id card_type_id twin_card_id orientation name first_position _destroy id]] },
        { documents_attributes: [%i[document id _destroy]] },
      ],
    )
  end

  def search_params
    params.permit(:sort, :sort_by, :page, :per_page, :q,
                  network_types: [], bay_ids: [], islet_ids: [], room_ids: [], frame_ids: [], cluster_ids: [],
                  gestion_ids: [], domaine_ids: [], modele_ids: [], stack_ids: [])
  end
end
