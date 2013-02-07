FactoryGirl.define do
  
  factory :group_admin_role, :class => MemberRole do
    name "group_admin"

    after :create do |role, e| 
      role.group = FactoryGirl.create :group
    end
  end

end