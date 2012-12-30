FactoryGirl.define do 

  factory :user, :class => Member do
    full_name "John Doe"
    email "test@test.cc"
    login "test"
    univ_year 2005
    enrollment_year 2006

    factory :user_with_group do
      after(:create) do |user, e|
        ms = user.memberships.build
        ms.group = FactoryGirl.build :group
      end
    end

    factory :user_as_group_leader do
      after :create do |user, e|
        ms = user.memberships.build :from_date => 2.days.ago, :to_date => nil
        ms.group = FactoryGirl.create :group
        ms.posts << FactoryGirl.create(:group_leader)
        ms.save
      end
    end

  end

end