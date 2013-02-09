# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  founded    :integer
#  url        :string(255)
#  mail_list  :string(255)
#  shortname  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  SZK_GRP_ID = 1

  attr_accessible :founded, :mail_list, :name, :shortname, :url

  has_many :memberships
  
  # shortcuts to members
  has_many :members, :through => :memberships

  validates :name, :shortname, :uniqueness => {:case_sensitive => false}
  validates :founded,
            :numericality => {:only_integer => true,
                              :greater_than => 1950,
                              :less_than_or_equal_to => Date.today.year}

  # Checks if the given member is in the group.
  # @param [Member] member to look for
  # @param [true, false] include_old indicates whether the query should take 
  #   old members into account
  def has_member?(member, include_old = false)
    is_member = members.include? member
    if is_member && !include_old
      # account for only active members
      is_member && memberships.active.where(:member_id => member).any?
    else
      is_member    
    end
  end

end
