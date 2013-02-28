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
  end

  test "login with a not existing db user" do
    set_test_data @users[0]
    assert_equal :reg, @controller.send(:authenticate_logic)

    set_test_data @users[1]
    assert_equal :reg, @controller.send(:authenticate_logic)
  end

  test "login with user with deleted flag" do
    FactoryGirl.create :user, :login => "virmember", :deleted => true
    set_test_data @users[0]
    assert_equal :deleted, @controller.send(:authenticate_logic)

    FactoryGirl.create :user, :login => "not_virmember", :deleted => true
    set_test_data @users[1]
    assert_equal :deleted, @controller.send(:authenticate_logic)
  end

  test "login with an existing db user without accepted membership" do
    FactoryGirl.create :user, :login => "virmember"
    set_test_data @users[0]
    assert_equal :wait, @controller.send(:authenticate_logic)

    FactoryGirl.create :user, :login => "not_virmember"
    set_test_data @users[1]
    assert_equal :wait, @controller.send(:authenticate_logic)
  end

  test "login with an imported user (with accepted membership), the first time" do
    FactoryGirl.create :user_with_group, :login => "virmember"
    set_test_data @users[0]
    assert_equal :reg, @controller.send(:authenticate_logic)

    FactoryGirl.create :user_with_group, :login => "not_virmember"
    set_test_data @users[1]
    assert_equal :reg, @controller.send(:authenticate_logic)
  end

  test "login with an existing db user with accepted membership, not the first time" do
    FactoryGirl.create :user_with_group, :login => "virmember", :last_active => "2012-08-15"
    set_test_data @users[0]
    assert_equal :ok, @controller.send(:authenticate_logic)

    FactoryGirl.create :user_with_group, :login => "not_virmember", :last_active => "2012-08-15"
    set_test_data @users[1]
    assert_equal :ok, @controller.send(:authenticate_logic)
  end

private

  def set_test_data(sso_user)
    member_attributes.each do |attr|
      @controller.request.env[attribute_mapping[attr.to_sym]] = sso_user[attr]
    end
    @controller.request.env[attribute_mapping[:entitlement]] = sso_user['entitlement']
  end

  def clear_test_data
    member_attributes.each do |attr|
      @controller.request.env[attribute_mapping[attr.to_sym]] = nil
    end
    @controller.request.env[attribute_mapping[:entitlement]] = nil
  end
end