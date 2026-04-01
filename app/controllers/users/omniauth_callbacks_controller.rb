# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_verify_authorized

    def openid_connect
      auth = request.env["omniauth.auth"]
      @user = User.find_by(oidc_uid: auth.uid) ||
              User.find_by("lower(email) = ?", auth.info.email.downcase)

      if @user.present?
        @user.update_column(:oidc_uid, auth.uid) if @user.oidc_uid.blank?
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
