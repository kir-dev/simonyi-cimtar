class Semester < ActiveRecord::Base
  attr_accessible :created_by_member, :min_scolarship_index, :semester, :valuation_date_from, :valuation_date_to
end
