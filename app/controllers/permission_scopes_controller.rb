# frozen_string_literal: true

class PermissionScopesController < ApplicationController
  skip_verify_authorized # TODO: remove me

  before_action :set_permission_scope, only: %i[show edit update destroy]

  # GET /permission_scopes or /permission_scopes.json
  def index
    @permission_scopes = PermissionScope.all
  end

  # GET /permission_scopes/1 or /permission_scopes/1.json
  def show; end

  # GET /permission_scopes/new
  def new
    @permission_scope = PermissionScope.new
  end

  # GET /permission_scopes/1/edit
  def edit; end

  # POST /permission_scopes or /permission_scopes.json
  def create
    @permission_scope = PermissionScope.new(permission_scope_params)

    respond_to do |format|
      if @permission_scope.save
        format.html { redirect_to @permission_scope, notice: "PermissionScope was successfully created." }
        format.json { render :show, status: :created, location: @permission_scope }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission_scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permission_scopes/1 or /permission_scopes/1.json
  def update
    respond_to do |format|
      if @permission_scope.update(permission_scope_params)
        format.html { redirect_to @permission_scope, notice: "PermissionScope was successfully updated." }
        format.json { render :show, status: :ok, location: @permission_scope }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission_scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permission_scopes/1 or /permission_scopes/1.json
  def destroy
    @permission_scope.destroy!

    respond_to do |format|
      format.html { redirect_to permission_scopes_path, status: :see_other, notice: "PermissionScope was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission_scope
    @permission_scope = PermissionScope.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def permission_scope_params
    params.expect(
      permission_scope: [
        :name, :role, :all_domains,
        { domaine_ids: [], user_ids: [] },
      ],
    )
  end
end
