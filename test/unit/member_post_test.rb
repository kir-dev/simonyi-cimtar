require 'test_helper'

class MemberPostTest < ActiveSupport::TestCase

  test "permissions resource must be unique for memberpost" do
    res = "group"
    post = FactoryGirl.build :member_post

    # only resource is unique
    post.permissions.build resource: res
    assert post.valid?

    # only resource is not unique
    post.permissions.build resource: res
    assert_not post.valid?
  end
end
