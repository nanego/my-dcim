# frozen_string_literal: true

class DisksController < ApplicationController
  before_action :set_disk, only: %i[show edit update destroy]

  # GET /disks
  # GET /disks.json
  def index
    @disks = Disk.all
  end

  # GET /disks/1
  # GET /disks/1.json
  def show; end

  # GET /disks/new
  def new
    @disk = Disk.new
  end

  # GET /disks/1/edit
  def edit; end

  # POST /disks
  # POST /disks.json
  def create
    @disk = Disk.new(disk_params)

    respond_to do |format|
      if @disk.save
        format.html { redirect_to @disk.server, notice: t(".flashes.created") }
        format.json { render :show, status: :created, location: @disk }
      else
        format.html { render :new }
        format.json { render json: @disk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disks/1
  # PATCH/PUT /disks/1.json
  def update
    respond_to do |format|
      if @disk.update(disk_params)
        format.html { redirect_to @disk.server, notice: t(".flashes.updated") }
        format.json { render :show, status: :ok, location: @disk }
      else
        format.html { render :edit }
        format.json { render json: @disk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disks/1
  # DELETE /disks/1.json
  def destroy
    @disk.destroy
    respond_to do |format|
      format.html { redirect_to disks_url, notice: t(".flashes.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disk
    @disk = Disk.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def disk_params
    params.expect(disk: %i[server_id disk_type_id quantity])
  end
end
