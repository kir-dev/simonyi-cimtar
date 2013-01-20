# == Schema Information
#
# Table name: valuations
#
#  id                :integer          not null, primary key
#  semester_id       :integer
#  member_id         :integer
#  scholarship_index :float
#  community         :boolean
#  professional      :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Valuation < ActiveRecord::Base
  belongs_to :semester
  belongs_to :member
  attr_accessible :community, :professional, :scholarship_index

  validates :scholarship_index, :presence => true
  validates :professional, :community, :inclusion => { :in => [true, false] }

  # passes if passes 2 out of 3 requirements
  def passed?
    [
      semester.min_scholarship_index <= scholarship_index,
      community?,
      professional?
    ].count { |p| p == true} >= 2
  end
end
