FactoryGirl.define do 

  factory :user, :class => Member do
    full_name "John Doe"
    email "test@test.cc"
    login "test"
    univ_year 2005
    enrollment_year 2006

    factory :user_with_group do
      after(:create) do |user, e|
        ms = FactoryGirl.build :membership
        user.memberships << ms
        user.save
      end
    end

    factory :user_as_group_leader do
      # after :create do |user, e|
      #   ms = user.memberships.build :from_date => 2.days.ago, :to_date => nil
      #   ms.group = FactoryGirl.create :group
      #   ms.accepted = true
      #   p = FactoryGirl.create :group_leader
      #   ms.posts << p
      #   ms.save
      # end
    end

    factory :user_with_job do
      after :create do |user, _|
        user.job_positions << FactoryGirl.create(:ms)
        user.save
      end
    end

  end

  factory :membership do
    from_date { Date.today }
    accepted true

    group
  end

end