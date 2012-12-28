require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:bela)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create member" do
    set_sso_request_values @request, login: "test"

    assert_difference('Member.count') do
      post :create, member: {address: @member.address,
                             email: @member.email + Member.count.to_s,
                             full_name: @member.full_name, 
                             hobby: @member.hobby,
                             intro: @member.intro, 
                             phone: @member.phone,
                             room: @member.room, 
                             univ_year: @member.univ_year,
                             enrollment_year: @member.enrollment_year,
                             nick: @member.nick,
                             login: 'unique_login_' + Member.count.to_s}
    end

    assert_redirected_to member_path(assigns(:member))
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should update member" do
    put :update, id: @member, member: {
          address: @member.address, 
          email: @member.email, 
          full_name: @member.full_name, 
          hobby: @member.hobby, 
          intro: @member.intro, 
          phone: @member.phone, 
          room: @member.room, 
          univ_year: @member.univ_year,
          enrollment_year: @member.enrollment_year
      }

    assert_redirected_to member_path(assigns(:member))
  end

end
