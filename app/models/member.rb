class Member < ActiveRecord::Base
  attr_accessible :address, :email, :fullName, :hobby, :intro, :phone, :room, :univYear
  #
  has_many :member_active_statuses, class_name: 'MemberActiveStatus', foreign_key: :member_id

  # mandatory fields
  validates :fullName, :email, :presence => true, :length => {:maximum => 130}
  validates :email, :uniqueness => {:case_sensitive => false}, :email => true
  validates :univYear, :presence => true, :numericality => {:greater_than => 1970, :less_than => 2030}

  validates :address, :hobby, :length => {:maximum => 250}
  validates :intro, :length => {:maximum => 1000}
  validates :phone, :length => {:maximum => 12}
  validates :room, :length => {:maximum => 10}
end
