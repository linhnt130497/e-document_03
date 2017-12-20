module SessionsHelper
  def current_user? user
    current_user == user
  end

  def checked_admin
    return if current_user.is_admin?
    flash[:warning] = t "sessions.flash.not_admin"
  end
end
