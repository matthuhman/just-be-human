class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_auth_token
  after_action :track_action



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :username, :first_name, :last_name)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :username, :first_name, :last_name, :password, :current_password)}
  end

  def set_auth_token
    if current_user
      gon.auth_token = current_user.authenticatable_salt
    end
  end

  def track_action
    ahoy.track "Action", request.path_parameters
  end

end
