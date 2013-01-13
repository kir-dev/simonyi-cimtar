require 'test_helper'

class PermissionTest < ActiveSupport::TestCase

  test "abilities method gives back all the abilities that the permission has" do
    perm = Permission.new can_read: true, can_create: true
    assert_equal [:create, :read], perm.abilities
  end

  test "abilities can be set through the abilities method" do
     perm = Permission.new
     perm.abilities = [:update, :destroy]

     assert perm.can_update?
     assert perm.can_destroy?
  end

  test "manage means all the permission has all the possible abilities" do
    perm = Permission.new
    perm.manage = true

    assert perm.can_create?
    assert perm.can_read?
    assert perm.can_update?
    assert perm.can_destroy?
  end

  test "setting manage to false should clear the abilities" do
    perm = Permission.new can_create: true, can_update: true
    assert perm.can_create?
    assert perm.can_update?

    perm.manage = false

    assert_equal [], perm.abilities
  end

  test "new permission has no abilities" do
    perm = Permission.new

    assert_equal [], perm.abilities
    assert_not perm.can_create?
    assert_not perm.can_read?
    assert_not perm.can_update?
    assert_not perm.can_destroy?
  end

  test "can_* attributes must have a boolean value" do
    perm = Permission.new

    assert_equal false, perm.can_update

    perm.can_update = nil
    assert_not perm.valid?
  end

  test "manage can be set only with a boolean or number value" do
    perm = Permission.new
    perm.manage = true
    assert perm.manage?

    perm = Permission.new
    perm.manage = 1
    assert perm.manage?

    perm = Permission.new
    perm.manage = "1"
    assert perm.manage?

    perm = Permission.new
    perm.manage = 0
    assert_not perm.manage?

    perm = Permission.new
    perm.manage = "0"
    assert_not perm.manage?
  end
end
