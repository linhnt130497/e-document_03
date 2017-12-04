class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      login_and_check_remember user
    else
      flash_login_error
    end
  end

  def destroy
    log_out if is_loged_in?
    redirect_to root_path
  end

  private

  def login_and_check_remember user
    log_in user
    params[:session][:remember_me] == Settings.user.remember_me.check ? remember(user) : forget(user)
    redirect_to user
  end

  def flash_login_error
    flash[:danger] = t "sessions.flash.error"
    render :new
  end
end