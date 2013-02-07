require "test_helper"

class GroupAdminTest < ActiveSupport::TestCase
  
  test "checking for other group should return false" do
    group_admin = FactoryGirl.create :group_admin_role
    other_group = FactoryGirl.create :group, name: "g1", shortname: "g1", founded: 2010
    
    ga = Roles::GroupAdminRole.new(nil, other_group)
    assert_not ga.check(:create, nil, Group.new)
  end

  test "GroupAdminRole constant should be loaded" do
    assert_nothing_raised do 
      Roles::GroupAdminRole
    end
  end

  test "can update Group" do
    group_admin = FactoryGirl.create :group_admin_role
    other_group = FactoryGirl.create :group, name: "g1", shortname: "g1", founded: 2010

    ga = Roles::GroupAdminRole.new(nil, group_admin.group)

    assert ga.check(:update, Group, group_admin.group)
    assert ga.check(:update, group_admin.group, group_admin.group)
    assert_not ga.check(:update, Group, other_group)
  end

end