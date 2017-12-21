class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include CommentsHelper
  include DocumentsHelper
  include UsersHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:warning] = t "cancancan.exception"
    redirect_to root_path
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i(name avatar uid provider)
    devise_parameter_sanitizer.permit :account_update, keys: %i(name avatar)
  end
end
