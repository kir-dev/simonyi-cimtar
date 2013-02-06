# == Schema Information
#
# Table name: member_roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MemberRole < ActiveRecord::Base
  belongs_to :group
  attr_accessible :name

  has_and_belongs_to_many :members
end
