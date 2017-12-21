class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :add_params_devise, if: :devise_controller?
  include SessionsHelper
  include CommentsHelper
  include DocumentsHelper
  include UsersHelper

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

  protected

  def add_params_devise
    devise_parameter_sanitizer.permit(:sign_up,
      keys: %i(name avatar coin up_count down_count uid provider))
    devise_parameter_sanitizer.permit(:account_update, keys: %i(name avatar))
  end
end
