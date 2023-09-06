# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def openid_connect
      auth = request.env["omniauth.auth"]
      @user = User.where('lower(email) = ?', auth["info"]["email"].downcase).first
      if @user.present?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'OpenID Connect') if is_navigational_format?
      else
        redirect_to new_user_registration_path error: 'Inscrivez-vous afin de pouvoir vous authentifier avec Cerbère'
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
