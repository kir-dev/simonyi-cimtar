FactoryGirl.define do
  
  factory :group_leader, :class => MemberPost do
    title "group leader"
    from_date { 1.year.ago }

    after :create do |post, _|
      post.permissions.create ability: "manage", resource: "group"
      post.permissions.create ability: "update", resource: "membership"
      post.permissions.create ability: "create", resource: "member_post"
      post.save
    end
  end

end