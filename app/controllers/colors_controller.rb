# frozen_string_literal: true

class ColorsController < ApplicationController
  before_action :set_color, only: [:show, :edit, :update, :destroy]

  def index
    @colors = sorted Color.order('parent_type asc, parent_id asc')
  end

  def show; end

  def new
    @color = Color.new
  end

  def edit; end

  def create
    @color = Color.new(color_params)

    respond_to do |format|
      if @color.save
        format.html { redirect_to '/colors', notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @color }
      else
        format.html { render :new }
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /colors/1
  # PATCH/PUT /colors/1.json
  def update
    respond_to do |format|
      if @color.update(color_params)
        format.html { redirect_to '/colors', notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @color }
      else
        format.html { render :edit }
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /colors/1
  # DELETE /colors/1.json
  def destroy
    @color.destroy
    respond_to do |format|
      format.html { redirect_to '/colors', notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_color
      @color = Color.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def color_params
      params.require(:color).permit(:parent_id, :parent_type, :code)
    end
end
