require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:one)
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
    assert_difference('Member.count') do
      post :create, member: {address: @member.address,
                             email: @member.email + Member.count.to_s,
                             full_name: @member.full_name, hobby: @member.hobby,
                             intro: @member.intro, phone: @member.phone,
                             room: @member.room, univ_year: @member.univ_year,
                             nick: @member.nick, deleted: @member.deleted,
                             login: 'unique_login_' + Member.count.to_s}
    end

    assert_redirected_to member_path(assigns(:member))
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should update member" do
    put :update, id: @member, member: {address: @member.address, email: @member.email, full_name: @member.full_name, hobby: @member.hobby, intro: @member.intro, phone: @member.phone, room: @member.room, univ_year: @member.univ_year}
    assert_redirected_to member_path(assigns(:member))
  end

end
