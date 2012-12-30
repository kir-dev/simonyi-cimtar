require 'test_helper'

class PermissionTest < ActiveSupport::TestCase

  setup do
    @perm = Permission.new ability: "read", resource: "group"
  end

  test "ability must be a symbol" do
    assert @perm.ability.is_a? Symbol
  end

  test "set ability as symbol" do
    @perm.ability = :create
    assert @perm.valid?
  end

  test "set ability to write" do
    @perm.ability = :write

    assert_not @perm.valid?
  end

end
