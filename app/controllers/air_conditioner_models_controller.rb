# frozen_string_literal: true

class AirConditionerModelsController < ApplicationController
  before_action :set_air_conditioner_model, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(AirConditionerModel.model_name.human, air_conditioner_models_path)
  end

  # GET /air_conditioner_models or /air_conditioner_models.json
  def index
    authorize! @air_conditioner_models = AirConditionerModel.joins(:manufacturer)

    @filter = ProcessorFilter.new(@air_conditioner_models, params)
    @air_conditioner_models = @filter.results
  end

  # GET /air_conditioner_models/1 or /air_conditioner_models/1.json
  def show; end

  # GET /air_conditioner_models/new
  def new
    authorize! @air_conditioner_model = AirConditionerModel.new
  end

  # GET /air_conditioner_models/1/edit
  def edit; end

  # POST /air_conditioner_models or /air_conditioner_models.json
  def create
    authorize! @air_conditioner_model = AirConditionerModel.new(air_conditioner_model_params)

    respond_to do |format|
      if @air_conditioner_model.save
        format.html { redirect_to @air_conditioner_model, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @air_conditioner_model }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @air_conditioner_model.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /air_conditioner_models/1 or /air_conditioner_models/1.json
  def update
    respond_to do |format|
      if @air_conditioner_model.update(air_conditioner_model_params)
        format.html { redirect_to @air_conditioner_model, notice: t(".flashes.updated"), status: :see_other }
        format.json { render :show, status: :ok, location: @air_conditioner_model }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @air_conditioner_model.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /air_conditioner_models/1 or /air_conditioner_models/1.json
  destroy_confirmation
  def destroy
    @air_conditioner_model.destroy!

    respond_to do |format|
      # TODO: use redirect_back_to_param_or
      format.html { redirect_to air_conditioner_models_path, notice: t(".flashes.destroyed"), status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_air_conditioner_model
    authorize! @air_conditioner_model = AirConditionerModel.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def air_conditioner_model_params
    params.expect(air_conditioner_model: %i[name manufacturer_id])
  end
end
