# == Schema Information
#
# Table name: members
#
#  id              :integer          not null, primary key
#  full_name       :string(255)
#  email           :string(255)
#  phone           :string(255)
#  room            :string(255)
#  address         :string(255)
#  intro           :text
#  univ_year       :integer
#  enrollment_year :integer
#  hobby           :string(255)
#  deleted         :boolean          default(FALSE)
#  login           :string(255)
#  nick            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Member < ActiveRecord::Base
  include Gravtastic
  gravtastic :secure => true,
             :filetype => :png,
             :default => 'mm'

  attr_readonly :login, :deleted
  attr_accessible :email, :full_name, :nick, :address, :hobby, :intro,
                  :phone, :univ_year, :enrollment_year, :room

  has_many :memberships

  # shortcuts
  has_many :groups, :through => :memberships
  has_many :posts, :through => :memberships

  has_many :job_positions, order: 'from_date DESC'

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
                              :less_than_or_equal_to => Date.today.year}

  validates :enrollment_year,
            :numericality => {:greater_than_or_equal_to => :univ_year}

  # validate deleted to be a boolean
  validates :deleted, :inclusion => { :in => [true, false] }

  validates :address, :hobby, :length => {:maximum => 250}
  validates :intro, :length => {:maximum => 1000}
  validates :phone, :length => {:maximum => 12}
  validates :room, :length => {:maximum => 10}
  validates :nick, :length => {:maximum => 100}

  def set_login_attr(attr)
    self.login = attr
  end

  def posts_in_group(group)
    if groups.include?(group)
      memberships.where(:group_id => group).first.posts
    else
      []
    end
  end

  # TODO: create attribute in db
  def admin?
    Rails.env.development? ? true : false
  end
end
