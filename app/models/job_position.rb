class JobPosition < ActiveRecord::Base
  belongs_to :member
  attr_accessible :company, :from_month, :from_year, :location, :title, :to_month, :to_year
end
