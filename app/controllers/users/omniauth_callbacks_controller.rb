# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_authorized

    def openid_connect
      auth = request.env["omniauth.auth"]
      @user = User.where("lower(email) = ?", auth["info"]["email"].downcase).first
      if @user.present?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "OpenID Connect") if is_navigational_format?
      else
        set_flash_message(:alert, :failure, kind: "OpenID Connect", reason: "Utilisateur non inscrit. Demandez l'accès à un admin.") if is_navigational_format?
        redirect_to root_path
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
