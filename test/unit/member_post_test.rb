require 'test_helper'

class MemberPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create memberpost when with multiple permissions" do
    hash = {
      "title" => "korevezeto",
      "from_date(1i)" => "2013",
      "from_date(2i)" => "1",
      "from_date(3i)" => "1",
      "permissions_attributes" =>
      {
        "1" => {
          "resource" => "groups",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage"  => "1",
          "_destroy" => "false"
        },
        "2" => {
          "resource" => "members",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage" => "0",
          "_destroy" => "false"}
        }
    }

  post = MemberPost.create_from_params hash
  assert_equal 4, post.permissions.size
  post.permissions.each { |e| assert_not_nil e.post }
  post.permissions.each { |e| assert e.valid? }

  end

  test "a member_post should have unique resource/ability pairs as permission" do
    hash = {
      "title" => "korevezeto",
      "from_date(1i)" => "2013",
      "from_date(2i)" => "1",
      "from_date(3i)" => "1",
      "permissions_attributes" =>
      {
        "1" => {
          "resource" => "groups",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage"  => "0",
          "_destroy" => "false"
        },
        "2" => {
          "resource" => "groups",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage" => "0",
          "_destroy" => "false"
        },
        "3" => {
          "resource" => "members",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage" => "0",
          "_destroy" => "false"}
        }
    }

    post = MemberPost.create_from_params hash
    assert_equal 6, post.permissions.size
    
  end

  test "when a member_post has manage ablity for a resource" do
    hash = {
      "title" => "korevezeto",
      "from_date(1i)" => "2013",
      "from_date(2i)" => "1",
      "from_date(3i)" => "1",
      "permissions_attributes" =>
      {
        "1" => {
          "resource" => "groups",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage"  => "1",
          "_destroy" => "false"
        },
        "2" => {
          "resource" => "groups",
          "abilities" =>
          [
            "read",
            "create",
            "update"
          ],
          "manage" => "0",
          "_destroy" => "false"}
        }
    }

    post = MemberPost.create_from_params hash
    assert_equal 1, post.permissions.size
    assert_equal :manage, post.permissions[0].ability
    
  end
end
