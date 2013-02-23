#encoding: utf-8
require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = FactoryGirl.create :user_with_group, :login => "one", :last_active => "2012-08-15"
  end

  # incomplete admin feature
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:members)
  # end

  test "should get new" do
    get :new
    assert_response :success
  end

  # can't test member/create method, because depends on sso attributes
  # needs to rewrite this test like app_controller_test

  # test "should create member" do
  #   assert_difference('Member.count') do
  #     group1 = FactoryGirl.create :group
  #     group2 = FactoryGirl.create :group

  #     post :create, member: {email: 'abc@de.fg',
  #                            full_name: 'Alma Béla',
  #                            univ_year: 2001,
  #                            enrollment_year: 2002,
  #                            login: 'unique_login',
  #                            join_groups: [group1.id, group2.id] }
  #   end

  #   assert_redirected_to member_path(assigns(:member))
  # end

  # test "should show member" do
  #   get :show, id: @member.id
  #   assert_response :success
  # end

  # test "should update member" do
  #   put :update, id: @member, member: {
  #         address: @member.address,
  #         email: @member.email,
  #         full_name: @member.full_name,
  #         hobby: @member.hobby,
  #         intro: @member.intro,
  #         phone: @member.phone,
  #         room: @member.room,
  #         univ_year: @member.univ_year,
  #         enrollment_year: @member.enrollment_year
  #     }

  #   assert_redirected_to member_path(assigns(:member))
  # end

end
