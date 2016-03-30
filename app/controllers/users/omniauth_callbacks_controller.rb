class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cas
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth["provider"], uid: strict_mask(auth["uid"])).try(:first)
    if @user.present?
      sign_in_and_redirect @user, event: :authentication
      #redirect_to root_url, notice: "Hyperspace !"
    else
      redirect_to new_user_session_path error: t(:omniauth_invalid_user)
    end
  end

  # Regexp.strict_mask("blah") = /^blah$/i + with regexp escaping
  def strict_mask(pattern)
    Regexp.new("^"+Regexp.escape(pattern)+"$", Regexp::IGNORECASE)
  end
end
