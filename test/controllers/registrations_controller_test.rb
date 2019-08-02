require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_up_params" do
    get registrations_sign_up_params_url
    assert_response :success
  end

  test "should get account_update_params" do
    get registrations_account_update_params_url
    assert_response :success
  end

end
