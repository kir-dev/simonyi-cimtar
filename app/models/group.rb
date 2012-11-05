class Group < ActiveRecord::Base
  attr_accessible :founded, :mail_list, :name, :shortname, :url
  #
  has_many :memberships, class_name: 'Membership', foreign_key: :group_id
  #has_many :members, :through => :memberships
  has_many :posts, class_name: 'MemberPost', foreign_key: :group_id

  validates :name, :shortname, :uniqueness => {:case_sensitive => false}
  validates :founded,
            :numericality => {:only_integer => true,
                              :greater_than => 1950,
                              :less_than_or_equal_to => Date.current.year}

  def get_active_memberships
    Membership.where(:to => nil, :accepted => true)
  end

  def get_old_memberships
    Membership.where(:to => !nil, :accepted => true)
  end

  def get_pending_memberships
    Membership.where(:accepted => false)
  end

end
