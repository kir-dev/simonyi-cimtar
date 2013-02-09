require 'test_helper'

class MemberRoleObserverTest < ActiveSupport::TestCase

  test "post history gets recorded when a role added to a memeber" do
    # set up member with group
    member = FactoryGirl.create :user_with_group
    group = member.groups.first
    role = FactoryGirl.create :group_admin_role, group: group

    with_observer(:member_role_observer) { member.roles << role }

    assert_not member.roles.empty?
    assert_not Post.where(title: "group_admin").empty?
  end

  test "post history 'to' field gets updated when role removed from member" do
    # set up member with group
    member = FactoryGirl.create :user_with_group
    group = member.groups.first
    role = FactoryGirl.create :group_admin_role, group: group

    with_observer :member_role_observer do
      # add role, and invoke observer to set up db
      member.roles << role

      # this is the real deal
      #member.roles.destroy role.id
      member.roles.delete(role)
    end

    assert member.roles.empty?
    assert_equal 0, MemberRole.count
    
    p = Post.where(title: "group_admin").first

    assert p.to.present?
  end

end
