class Group < ActiveRecord::Base
  attr_accessible :founded, :mail_list, :name, :shortname, :url

  has_many :memberships
  
  # shortcuts to members and posts
  has_many :members, :through => :memberships
  has_many :posts, :through => :memberships

  validates :name, :shortname, :uniqueness => {:case_sensitive => false}
  validates :founded,
            :numericality => {:only_integer => true,
                              :greater_than => 1950,
                              :less_than_or_equal_to => Date.today.year}

  def get_active_memberships
    Membership.where(:to_date => nil,
                     :group_id => self.id,
                     :accepted => true,
                     :deleted => false).joins(:member).order('members.full_name')
  end

  def get_old_memberships
    Membership.where(:group_id => self.id,
                     :accepted => true,
                     :deleted => false).where('to_date IS NOT NULL').joins(:member).order('members.full_name')
  end

  def get_pending_memberships
    Membership.where(:accepted => false,
                     :group_id => self.id).order(:created_at)
  end

end
