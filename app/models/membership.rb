class Membership < ActiveRecord::Base
  attr_accessible :from_date, :to_date, :accepted, :deleted

  belongs_to :group
  belongs_to :member
  belongs_to :post, :class_name => "MemberPost"

  validates_date :from_date,
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :allow_nil => true,
                 :on_or_after => :from_date
end
