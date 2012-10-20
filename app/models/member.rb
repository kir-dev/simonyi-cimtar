class Member < ActiveRecord::Base
  attr_readonly :login
  attr_accessible :email, :full_name, :nick, :address, :hobby, :intro, :phone, :univ_year, :room
  #
  has_many :memberships, class_name: 'Membership', foreign_key: :member_id
  has_many :posts, class_name: 'MemberPost', foreign_key: :member_id

  # mandatory fields
  validates :full_name, :email, :login, :presence => true, :length => {:maximum => 130}
  validates :email, :email => true, :uniqueness => {:case_sensitive => false}
  validates :login, :uniqueness => {:case_sensitive => false}

  validates :univ_year, :on => :update,
            :numericality => {:only_integer => true, :greater_than => 1950, :less_than => 2020}

  validates :address, :hobby, :length => {:maximum => 250}
  validates :intro, :length => {:maximum => 1000}
  validates :phone, :length => {:maximum => 12}
  validates :room, :length => {:maximum => 10}
  validates :nick, :length => {:maximum => 100}
end
