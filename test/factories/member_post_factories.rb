FactoryGirl.define do
  
  factory :member_post, :class => MemberPost do
    title "member"
    from_date { 1.year.ago }
  end

  factory :group_leader, :class => MemberPost do
    title "group leader"
    from_date { 1.year.ago }

    after :create do |post, _|
      p = post.permissions.build resource: "group"
      p.manage = true
      post.permissions.create can_update: true, resource: "membership"
      post.permissions.create can_create: true, resource: "member_post"
      post.save
    end
  end

end