FactoryGirl.define do
  
  factory :ms, :class => JobPosition do
    company "Microsoft"
    location "Redmond, WA"
    title "senior developer"
    from_date { 2.years.ago }
    present_job true
  end
end