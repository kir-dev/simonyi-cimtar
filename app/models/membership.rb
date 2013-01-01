# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  group_id   :integer
#  from_date  :datetime
#  to_date    :datetime
#  accepted   :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  attr_accessible :from_date, :to_date

  belongs_to :group
  belongs_to :member
  has_many :posts, :class_name => "MemberPost", :include => :permissions

  validates_date :from_date,
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :allow_nil => true,
                 :on_or_after => :from_date

  # accepted and deleted default to false by the DB
  # validate these to be boolean anyway
  validates :accepted, :deleted, :inclusion => { :in => [true, false] }

  # always look for the not deleted records
  default_scope where(:deleted => false)

  scope :accepted, where(:accepted => true)

  # gets the pending memberships
  scope :pending, where(:accepted => false)

  # gets the active memberships, implies accepted as well
  scope :active, accepted.where(:to_date => nil)

  #gets the old memberships, implies accepted as well
  scope :old, accepted.where('to_date IS NOT NULL')

  scope :order_by_member_name, joins(:member).order('members.full_name')

end
