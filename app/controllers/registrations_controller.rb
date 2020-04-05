class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :phone_number, :birth_date, :password, :password_confirmation, :city, :region, :postal_code, :country, :time_zone, :allow_email)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :current_password, :city, :region, :postal_code, :country, :time_zone, :allow_email)
  end
end
