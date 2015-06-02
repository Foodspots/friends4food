class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
before_action :authenticate_user!
before_filter :current_coordinates

protect_from_forgery with: :exception
before_filter :configure_permitted_parameters, if: :devise_controller?

RECORDS_PER_PAGE = ENV['RECORDS_PER_PAGE'] || 10
has_mobile_fu false

def current_coordinates
  @latitude = cookies[:latitude]
  @longitude = cookies[:longitude]
end

protected

def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :image_file_name, :email, :password, :password_confirmation, :current_password) }
   devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :image_file_name, :email, :password, :password_confirmation, :current_password) }
   devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :image_file_name, :email, :password, :password_confirmation, :current_password) }
end

end
