# frozen_string_literal: true

class ColorsController < ApplicationController
  before_action :set_color, only: %i[show edit update destroy]
  before_action except: %i[index] do
    breadcrumb.add_step(Color.model_name.human.pluralize, colors_path)
  end

  def index
    @colors = sorted Color.order(:parent_type, :parent_id)
  end

  def show; end

  def new
    authorize! @color = Color.new
  end

  def edit; end

  def create
    authorize! @color = Color.new(color_params)

    respond_to do |format|
      if @color.save
        format.html { redirect_to_new_or_to(@color, notice: t(".flashes.created")) }
        format.json { render :show, status: :created, location: @color }
      else
        format.html { render :new }
        format.json { render json: @color.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /colors/1
  # PATCH/PUT /colors/1.json
  def update
    respond_to do |format|
      if @color.update(color_params)
        format.html { redirect_to @color, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @color }
      else
        format.html { render :edit }
        format.json { render json: @color.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /colors/1
  # DELETE /colors/1.json
  def destroy
    @color.destroy
    respond_to do |format|
      format.html { redirect_to colors_url, notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_color
    authorize! @color = Color.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def color_params
    params.expect(color: %i[parent_id parent_type code])
  end
end
