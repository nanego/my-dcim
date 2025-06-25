# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :admin_only, only: %i[new create]
    before_action :set_user, only: %i[edit update]

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to user_path(@user), notice: t(".flashes.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    protected

    # The path used after sign up. You need to overwrite this method
    # in your own RegistrationsController.
    def after_sign_up_path_for(_resource)
      new_user_session_path
    end

    # Signs in a user on sign up. You can overwrite this method in your own
    # RegistrationsController.
    def sign_up(resource_name, resource)
      # DO NOT sign_in(resource_name, resource)
    end

    private

    def set_user
      authorize! @user = User.find(params[:user_id])
    end

    def user_params
      params.expect(user: %i[name email])
    end
  end
end
