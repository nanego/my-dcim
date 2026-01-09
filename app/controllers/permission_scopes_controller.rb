# frozen_string_literal: true

class PermissionScopesController < ApplicationController
  before_action :set_permission_scope, only: %i[show edit update destroy]

  before_action except: :index do
    breadcrumb.add_step(PermissionScope.model_name.human.pluralize, permission_scopes_path)
  end

  # GET /permission_scopes
  def index
    @permission_scopes = authorize! PermissionScope.includes(:users)
  end

  # GET /permission_scopes/1
  def show
    @permission_scope_users = @permission_scope.permission_scope_users
      .joins(:user)
      .where(user: User.unsuspended)
      .order(User.arel_table[:name] => :asc)
  end

  # GET /permission_scopes/new
  def new
    @permission_scope = authorize! PermissionScope.new
  end

  # GET /permission_scopes/1/edit
  def edit; end

  # POST /permission_scopes
  def create
    @permission_scope = authorize! PermissionScope.new(permission_scope_params)

    respond_to do |format|
      if @permission_scope.save
        format.html { redirect_to @permission_scope, notice: t(".flashes.created") }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /permission_scopes/1
  def update
    respond_to do |format|
      if @permission_scope.update(permission_scope_params)
        format.html { redirect_to @permission_scope, notice: t(".flashes.updated") }
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  # DELETE /permission_scopes/1
  destroy_confirmation
  def destroy
    @permission_scope.destroy!

    respond_to do |format|
      format.html { redirect_to permission_scopes_path, status: :see_other, notice: t(".flashes.destroyed") }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission_scope
    @permission_scope = authorize! PermissionScope.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def permission_scope_params
    params.expect(
      permission_scope: [
        :name, :all_domains,
        { domaine_ids: [], user_ids: [] },
      ],
    )
  end
end
