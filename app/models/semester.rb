class Semester < ActiveRecord::Base
  attr_accessible :min_scolarship_index, :semester, :valuation_date_from, :valuation_date_to

  belongs_to :created_by, class_name: "Member", foreign_key: "created_by"  
end
