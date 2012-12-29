# == Schema Information
#
# Table name: semesters
#
#  id                   :integer          not null, primary key
#  semester             :string(255)
#  valuation_date_from  :datetime
#  valuation_date_to    :datetime
#  min_scolarship_index :float
#  created_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Semester < ActiveRecord::Base
  attr_accessible :min_scolarship_index, :semester, :valuation_date_from, :valuation_date_to

  belongs_to :created_by, class_name: "Member", foreign_key: "created_by"  
end
