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
#  last_active     :datetime
#

class Member < ActiveRecord::Base
  include Gravtastic
  gravtastic :secure => true,
             :filetype => :png,
             :default => 'mm'

  attr_readonly :login, :deleted
  attr_accessible :email, :full_name, :nick, :address, :hobby, :intro,
                  :phone, :univ_year, :enrollment_year, :room, :last_active

  attr_accessor :join_groups # transient attribute, used in the registration process

  has_many :memberships

  # shortcuts
  has_many :groups, :through => :memberships

  has_many :job_positions, order: 'from_date DESC'

  has_many :member_roles
  has_many :roles, :through => :member_roles, :before_remove => :before_role_destroyed

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

  def name
    full_name
  end

  def active_memberships
    memberships.active.joins(:group).order('groups.name')
  end

  def has_valid_membership?
    memberships.accepted.count > 0
  end

  # get all the roles that a user has
  def get_acting_roles
    acting_roles = []
    roles.each do |role|
      acting_roles << ActingRole.create_role(role.name.to_sym, self, role.group)
    end
    acting_roles
  end

  def posts(group, what = :active)
    posts = self.memberships.active.where(group_id: group).first.posts
    if what == :active
      posts.where(to: nil)
    elsif what == :old
      posts.where('"to" IS NOT NULL')
    else
      posts
    end
  end

private  

  def before_role_destroyed(role)
    member_role = member_roles.where(role_id: role).first
    # HACK: call observer directly
    if ActiveRecord::Base.observers.include? :member_role_observer
      # observers are singletons
      MemberRoleObserver.instance.before_destroy(member_role)
    end
    # returning true, so the callback chain never gets interrupted
    true
  end
end
