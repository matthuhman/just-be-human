class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    # binding.pry
    respond_with *args, options, &blk
  end


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :username, :first_name, :last_name)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :username, :first_name, :last_name, :password, :current_password)}
    end

end
