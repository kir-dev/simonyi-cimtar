class Membership < ActiveRecord::Base
  attr_accessible :group_id, :member_id, :from, :to, :accepted

  belongs_to :group, :class_name => 'Group'
  belongs_to :member, :class_name => 'Member'

  validates_date :from,
                 :on_or_before => lambda { Date.current }

  validates_date :to,
                 :allow_nil => true,
                 :after => :to
end
