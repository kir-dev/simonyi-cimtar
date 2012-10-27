require 'test_helper'

class AppControllerTest < ActionController::TestCase
  include AppAuthHelper

  setup do
    @users = YAML.load_file(Rails.root.join("test/functional/sso_users.yml"))
    @controller = HomeController.new
    get :index
    clear_test_data
  end

  test "login with no sso user" do
    assert_equal :goto_login, @controller.send(:authenticate_logic)

    assert_response :redirect
    assert_equal Rails.application.config.login_url, @controller.response.header['Location']
  end

  test "login with a not registered but member on vir user aka newuser" do
    set_test_data @users[0]
    assert_equal :reg, @controller.send(:authenticate_logic)
  end

  test "login with a registered and member on vir user aka user" do
    set_test_data @users[1]
    assert_equal :ok, @controller.send(:authenticate_logic)
  end

  test "login with a not registered and not member on vir user aka hacker" do
    set_test_data @users[2]
    assert_equal :access_denied, @controller.send(:authenticate_logic)
  end

  test "login with a registered and not member on vir user aka oldboy" do
    set_test_data @users[3]
    assert_equal :ok, @controller.send(:authenticate_logic)
  end

  test "login with a registered and deleted user aka banned troll" do
    set_test_data @users[4]
    assert_equal :deleted, @controller.send(:authenticate_logic)
  end

  private
  def set_test_data(sso_user)
    member_attributes.each do |attr|
      @controller.request.env[attribute_mapping[attr.to_sym]] = sso_user[attr]
    end
    @controller.request.env[attribute_mapping[:entitlement]] = sso_user['entitlement']
  end

  private
  def clear_test_data()
    member_attributes.each do |attr|
      @controller.request.env[attribute_mapping[attr.to_sym]] = nil
    end
    @controller.request.env[attribute_mapping[:entitlement]] = nil
  end
end