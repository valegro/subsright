class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :user_time_zone
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  private

  def admin_user_time_zone(&block)
    time_zone = current_admin_user.try(:time_zone) || 'Melbourne'
    Time.use_zone(time_zone, &block)
  end

  def user_time_zone(&block)
    time_zone = current_user.try(:time_zone) || 'Melbourne'
    Time.use_zone(time_zone, &block)
  end
end
