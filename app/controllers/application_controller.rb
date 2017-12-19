class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include CommentsHelper
  include DocumentsHelper
  include UsersHelper

  def logged_in_user
    return if is_loged_in?
    flash[:danger] = t "users.flash.danger_login"
    redirect_to login_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_url
  end

  def current_ability
    Ability.new current_user, namespace
  end

  private

  def namespace
    controller_name_segments = params[:controller].split("/")
    controller_name_segments.pop
    controller_name_segments.join("/").camelize
  end
end
