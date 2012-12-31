FactoryGirl.define do
  
  factory :manage_group_permission, :class => Permission do
    ability "manage"
    resource "group"
  end

end