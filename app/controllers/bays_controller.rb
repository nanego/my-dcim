# frozen_string_literal: true

class BaysController < ApplicationController
  include RoomsHelper
  include ColumnsPreferences

  DEFAULT_COLUMNS = %w[name room_id islet_id frame_id lane position server_id].freeze
  AVAILABLE_COLUMNS = %w[name room_id islet_id frame_id lane position server_id width depth bay_type_id access_control manufacturer_id].freeze

  columns_preferences_with model: Bay, default: DEFAULT_COLUMNS, available: AVAILABLE_COLUMNS

  before_action :set_bay, only: %i[edit update destroy show]
  before_action except: %i[index] do
    breadcrumb.add_step(t("bays.index.title"), bays_path)
  end

  def index
    authorize! @bays = Bay.joins(islet: :room).order("rooms.position, islets.name, bays.lane, bays.position")
    @filter = ProcessorFilter.new(@bays, params)

    @bays = @filter.results.uniq
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    authorize! @bay = Bay.new
    @bay.assign_attributes(bay_params) if params[:bay]
  end

  def edit; end

  def create
    authorize! @bay = Bay.new(bay_params)

    unless @bay.position.nil?
      position = @bay.position
      @bay.position = nil
    end

    respond_to do |format|
      if @bay.save
        @bay.set_list_position(position) if position

        format.html { form_redirect_to_new_or_to(@bay, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @bay }
      else
        format.html { render :new }
        format.json { render json: @bay.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @bay.update(bay_params)
        format.html { redirect_to @bay, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @bay }
      else
        format.html { render :edit }
        format.json { render json: @bay.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    Bay.acts_as_list_no_update do
      if @bay.destroy
        respond_to do |format|
          format.html { form_redirect_to bays_url, notice: t(".flashes.destroyed") }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { form_redirect_to bays_url, alert: @bay.errors.full_messages_for(:base).join(", ") }
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bay
    authorize! @bay = Bay.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bay_params
    params.expect(bay: %i[name lane position width depth access_control bay_type_id islet_id manufacturer_id])
  end
end
