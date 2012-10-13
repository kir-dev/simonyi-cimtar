class Member < ActiveRecord::Base
  #attr_accessible :address, :email, :fullName, :hobby, :intro, :phone, :room, :univYear
  #
  has_many :memberships, class_name: 'MemberShip', foreign_key: :member_id
  has_many :posts, class_name: 'MemberPost', foreign_key: :member_id

  # mandatory fields
  validates :full_name, :email, :presence => true, :length => {:maximum => 130}
  validates :email, :uniqueness => {:case_sensitive => false}, :email => true
  validates :univ_year, :presence => true, :numericality => {:greater_than => 1970, :less_than => 2030}

  validates :address, :hobby, :length => {:maximum => 250}
  validates :intro, :length => {:maximum => 1000}
  validates :phone, :length => {:maximum => 12}
  validates :room, :length => {:maximum => 10}
end
