# == Schema Information
#
# Table name: semesters
#
#  id                    :integer          not null, primary key
#  semester              :string(255)
#  valuation_date_from   :datetime
#  valuation_date_to     :datetime
#  min_scholarship_index :float
#  created_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Semester < ActiveRecord::Base
  attr_accessible :min_scholarship_index, :semester, :valuation_date_from, :valuation_date_to

  belongs_to :created_by, class_name: "Member", foreign_key: "created_by"

  validates :semester, 
            :min_scholarship_index, 
            :valuation_date_to, 
            :valuation_date_from,
            presence: true

  validates_date :valuation_date_to, on_or_after: :valuation_date_from

  def self.current_valuation_period
    periods = where("valuation_date_from <= ? AND valuation_date_to >= ?", DateTime.now.end_of_day, DateTime.now.beginning_of_day).all
    raise "Cannot be more than one valuation perid at a time. Contant maintainers!" if periods.size > 1

    periods.first
  end
end
