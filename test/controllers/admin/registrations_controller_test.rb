require "test_helper"

class Admin::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_registrations_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_registrations_create_url
    assert_response :success
  end
end
