FactoryGirl.define do
  
  factory :group_leader, :class => MemberPost do
    title "group leader"
    from_date { 1.year.ago }

    after :create do |post, _|
      # Permission.create ability: "manage", resource: "group"
      post.permissions.create ability: "manage", resource: "group"
    end
  end

end