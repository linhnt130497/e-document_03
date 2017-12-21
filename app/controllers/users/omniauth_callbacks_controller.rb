class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth request.env["omniauth.auth"]
    if @user && @user.persisted?
      sign_in_and_redirect @user
      flash[:notice] = t "devise.omniauth_callbacks.success",
        kind: Settings.omniauth.facebook
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = User.from_omniauth request.env["omniauth.auth"]
    if @user && @user.persisted?
      sign_in_and_redirect @user
      flash[:notice] = t "devise.omniauth_callbacks.success",
        kind: Settings.omniauth.google
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
