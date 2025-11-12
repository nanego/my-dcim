# frozen_string_literal: true

class PermissionScopeUsersController < ApplicationController
  before_action :set_permission_scope
  before_action :set_permission_scope_user, only: %i[destroy]

  # POST /permission_scope_users
  def create
    @permission_scope_user = authorize! @permission_scope.permission_scope_users.build(permission_scope_user_params)

    respond_to do |format|
      if @permission_scope_user.save
        flash[:notice] = t(".flashes.created")

        format.html { redirect_to @permission_scope }
        format.turbo_stream { render status: :see_other }
      else
        format.html { render :new, status: :unprocessable_content }
        format.turbo_stream { render :new, status: :unprocessable_content }
      end
    end
  end

  # DELETE /permission_scope_users/1
  def destroy
    @permission_scope_user.destroy!

    flash[:notice] = t(".flashes.destroyed") # rubocop:disable Rails/ActionControllerFlashBeforeRender

    respond_to do |format|
      format.html { redirect_to permission_scope_path(@permission_scope), status: :see_other }
      format.turbo_stream { render status: :see_other }
    end
  end

  private

  def set_permission_scope
    @permission_scope = PermissionScope.find(params[:permission_scope_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_permission_scope_user
    @permission_scope_user = authorize! @permission_scope.permission_scope_users.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permission_scope_user_params
    params.expect(permission_scope_user: %i[user_id])
  end
end
