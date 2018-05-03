class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cas
    auth = request.env["omniauth.auth"]
    @user = User.where('lower(email) = ?', auth["uid"].downcase).first
    if @user.present?
      sign_in_and_redirect @user, event: :authentication
      #redirect_to root_url, notice: "Hyperspace !"
    else
      redirect_to new_user_registration_path error: 'Inscrivez-vous afin de pouvoir vous authentifier avec Cerbère'
    end
  end

end
