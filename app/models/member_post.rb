class MemberPost < ActiveRecord::Base
  attr_accessible :title, :from_date, :to_date

  belongs_to :membership

  validates :title, :from_date, :presence => true

  validates_date :from_date,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :on_or_before => lambda { Date.today },
                 :on_or_after => :from_date
end
