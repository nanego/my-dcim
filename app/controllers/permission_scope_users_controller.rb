# frozen_string_literal: true

class PermissionScopeUsersController < ApplicationController
  before_action :set_permission_scope
  before_action :set_permission_scope_user, only: %i[destroy]

  # POST /permission_scope_users
  def create
    @permission_scope_user = authorize! PermissionScopeUser.new(permission_scope_user_params)

    respond_to do |format|
      if @permission_scope_user.save
        format.html { redirect_to @permission_scope, notice: t(".flashes.created") }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_content }
        format.turbo_stream
      end
    end
  end

  # DELETE /permission_scope_users/1
  def destroy
    @permission_scope.destroy!

    respond_to do |format|
      format.html { redirect_to permission_scope_path(@permission_scope), status: :see_other, notice: t(".flashes.destroyed") }
      format.turbo_stream
    end
  end

  private

  def set_permission_scope
    @permission_scope = authorize! PermissionScope.find(params[:permission_scope_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_permission_scope_user
    @permission_scope_user = @permission_scope.permission_scope_users.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permission_scope_user_params
    params.expect(
      permission_scope: [
        :name, :role, :all_domains,
        { domaine_ids: [], user_ids: [] },
      ],
    )
  end
end
