# frozen_string_literal: true

class ManufacturersController < ApplicationController
  before_action :set_manufacturer, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Manufacturer.model_name.human.pluralize, manufacturers_path)
  end

  # GET /manufacturers
  # GET /manufacturers.json
  def index
    @filter = ProcessorFilter.new(Manufacturer.sorted, params)
    authorize! @manufacturers = @filter.results

    @bays_counts = authorized_scope(Bay.all).group(:manufacturer_id).count(:manufacturer_id)
    @servers_counts = authorized_scope(Server.all).group(:manufacturer_id).count(:manufacturer_id)
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.json
  def show; end

  # GET /manufacturers/new
  def new
    authorize! @manufacturer = Manufacturer.new
  end

  # GET /manufacturers/1/edit
  def edit; end

  # POST /manufacturers
  # POST /manufacturers.json
  def create
    authorize! @manufacturer = Manufacturer.new(manufacturer_params)

    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to_new_or_to(@manufacturer, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @manufacturer }
      else
        format.html { render :new }
        format.json { render json: @manufacturer.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /manufacturers/1
  # PATCH/PUT /manufacturers/1.json
  def update
    respond_to do |format|
      if @manufacturer.update(manufacturer_params)
        format.html { redirect_to @manufacturer, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @manufacturer }
      else
        format.html { render :edit }
        format.json { render json: @manufacturer.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.json
  destroy_confirmation
  def destroy
    if @manufacturer.destroy
      respond_to do |format|
        format.html { redirect_to manufacturers_url, notice: t(".flashes.destroyed") }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to manufacturers_url, alert: @manufacturer.errors.full_messages_for(:base).join(", ") }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_manufacturer
    authorize! @manufacturer = Manufacturer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manufacturer_params
    params.expect(manufacturer: %i[name description documentation_url])
  end
end
