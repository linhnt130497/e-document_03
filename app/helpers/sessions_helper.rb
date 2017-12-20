module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def current_user? user
    current_user == user
  end
end
