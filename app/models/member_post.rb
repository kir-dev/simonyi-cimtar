# == Schema Information
#
# Table name: member_posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  from_date  :datetime
#  to_date    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MemberPost < ActiveRecord::Base
  attr_accessible :title, :from_date, :to_date

  has_many :memberships

  validates :title, :from_date, :presence => true

  validates_date :from_date,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :on_or_before => lambda { Date.today },
                 :on_or_after => :from_date
end
