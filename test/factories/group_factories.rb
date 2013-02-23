FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group#{n}" }
    sequence(:shortname) { |n| "G#{n}" }
    founded 2001
  end
end