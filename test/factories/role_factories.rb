FactoryGirl.define do
  
  factory :group_admin_role, :class => Role do
    name "group_admin"
    group
  end

end