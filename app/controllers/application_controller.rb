class ApplicationController < ActionController::Base

       protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :username, :first_name, :last_name)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :username, :first_name, :last_name, :password, :current_password)}
          end
end
