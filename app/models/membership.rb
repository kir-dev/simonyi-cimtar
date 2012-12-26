class Membership < ActiveRecord::Base
  attr_accessible :group_id, :member_id, :from_date, :to_date, :accepted, :deleted

  belongs_to :group, :class_name => 'Group'
  belongs_to :member, :class_name => 'Member'

  validates_date :from_date,
                 :on_or_before => lambda { Time.now }

  validates_date :to_date,
                 :allow_nil => true,
                 :on_or_after => :from_date
end
