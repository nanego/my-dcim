# frozen_string_literal: true

class DiskTypesController < ApplicationController
  before_action :set_disk_type, only: [:show, :edit, :update, :destroy]

  # GET /disk_types
  # GET /disk_types.json
  def index
    @disk_types = DiskType.all
  end

  # GET /disk_types/1
  # GET /disk_types/1.json
  def show
  end

  # GET /disk_types/new
  def new
    @disk_type = DiskType.new
  end

  # GET /disk_types/1/edit
  def edit
  end

  # POST /disk_types
  # POST /disk_types.json
  def create
    @disk_type = DiskType.new(disk_type_params)

    respond_to do |format|
      if @disk_type.save
        format.html { redirect_to @disk_type, notice: 'Disk type was successfully created.' }
        format.json { render :show, status: :created, location: @disk_type }
      else
        format.html { render :new }
        format.json { render json: @disk_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disk_types/1
  # PATCH/PUT /disk_types/1.json
  def update
    respond_to do |format|
      if @disk_type.update(disk_type_params)
        format.html { redirect_to @disk_type, notice: 'Disk type was successfully updated.' }
        format.json { render :show, status: :ok, location: @disk_type }
      else
        format.html { render :edit }
        format.json { render json: @disk_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disk_types/1
  # DELETE /disk_types/1.json
  def destroy
    @disk_type.destroy
    respond_to do |format|
      format.html { redirect_to disk_types_url, notice: 'Disk type a bien été supprimé.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_disk_type
      @disk_type = DiskType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disk_type_params
      params.require(:disk_type).permit(:unit, :quantity, :technology)
    end
end
