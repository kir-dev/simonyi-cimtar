# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  belongs_to :group
  attr_accessible :name

  has_many :member_roles
  has_many :members, :through => :member_roles
end
