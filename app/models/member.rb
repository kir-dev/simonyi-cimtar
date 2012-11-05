class Member < ActiveRecord::Base
  include Gravtastic
  gravtastic :secure => true,
             :filetype => :png,
             :default => 'mm'

  attr_readonly :login, :deleted
  attr_accessible :email, :full_name, :nick, :address, :hobby, :intro,
                  :phone, :univ_year, :enrollment_year, :room

  #
  has_many :memberships, class_name: 'Membership', foreign_key: :member_id
  has_many :posts, class_name: 'MemberPost', foreign_key: :member_id
  has_many :job_positions, class_name: 'JobPosition', foreign_key: :member_id

  # mandatory fields
  validates :full_name,
            :length => 4..130

  validates :email,
            :email => true,
            :presence => true,
            :length => {:maximum => 130},
            :uniqueness => {:case_sensitive => false}

  validates :login,
            :presence => true,
            :length => {:maximum => 130},
            :uniqueness => {:case_sensitive => false}

  validates :univ_year, :enrollment_year,
            :numericality => {:only_integer => true,
                              :greater_than => 1950,
                              :less_than_or_equal_to => Date.current.year}

  validates :enrollment_year,
            :numericality => {:greater_than_or_equal_to => :univ_year}

  validates :address, :hobby, :length => {:maximum => 250}
  validates :intro, :length => {:maximum => 1000}
  validates :phone, :length => {:maximum => 12}
  validates :room, :length => {:maximum => 10}
  validates :nick, :length => {:maximum => 100}

  def set_login_attr(attr)
    self.login = attr
  end
end
