class Group < ActiveRecord::Base
  attr_accessible :founded, :mail_list, :name, :shortname, :url
  #
  has_many :memberships, class_name: 'Membership', foreign_key: :member_id
  has_many :posts, class_name: 'MemberPost', foreign_key: :member_id

  validates :name, :shortname, :uniqueness => {:case_sensitive => false}
  validates :founded,
            :numericality => {:only_integer => true, :greater_than => 1950, :less_than => 2020}
end
