FactoryGirl.define do
  
  factory :manage_group_permission, :class => Permission do
    manage true
    resource "group"
  end

end