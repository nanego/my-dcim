# frozen_string_literal: true

class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]

  # GET /permissions or /permissions.json
  def index
    @permissions = Permission.all
  end

  # GET /permissions/1 or /permissions/1.json
  def show; end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit; end

  # POST /permissions or /permissions.json
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to @permission, notice: "Permission was successfully created." }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to @permission, notice: "Permission was successfully updated." }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    @permission.destroy!

    respond_to do |format|
      format.html { redirect_to permissions_path, status: :see_other, notice: "Permission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def permission_params
    params.expect(permission: [:name])
  end
end
