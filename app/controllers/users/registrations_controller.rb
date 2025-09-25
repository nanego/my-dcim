# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_verify_authorized

    before_action :admin_only, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter

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
  end
end
