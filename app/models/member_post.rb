# == Schema Information
#
# Table name: member_posts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  from_date     :datetime
#  to_date       :datetime
#  membership_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MemberPost < ActiveRecord::Base
  RESOURCES = %w(group member membership).freeze

  attr_accessible :title, :from_date, :to_date, :permissions_attributes

  belongs_to :membership
  has_many :permissions, :foreign_key => "post_id", :dependent => :destroy

  accepts_nested_attributes_for :permissions, :allow_destroy => true

  validates :title, :from_date, :presence => true
  validates_associated :permissions

  validate :one_permission_for_on_resource

  validates_date :from_date,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :on_or_before => lambda { Date.today },
                 :on_or_after => :from_date,
                 :allow_nil => true

private
  # permission's resource has to be unique for the memberpost
  def one_permission_for_on_resource
    by_res = self.permissions.group_by { |p| p.resource }
    if by_res.any? { |_, v| v.size > 1 }
      errors.add :unique_resource, "permission's resource has to be unique for the post"
    end
  end

end
