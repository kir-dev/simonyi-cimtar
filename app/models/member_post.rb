# == Schema Information
#
# Table name: member_posts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  from_date     :datetime
#  to_date       :datetime
#  membership_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MemberPost < ActiveRecord::Base
  attr_accessible :title, :from_date, :to_date

  belongs_to :membership
  has_many :permissions, :foreign_key => "post_id", :dependent => :destroy

  accepts_nested_attributes_for :permissions

  validates :title, :from_date, :presence => true
  validates_associated :permissions

  validates_date :from_date,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.today }

  validates_date :to_date,
                 :on_or_before => lambda { Date.today },
                 :on_or_after => :from_date,
                 :allow_nil => true

  # Creates a new MemberPost object from the given params hash.
  # It might create more than one permission for the post. 
  # 
  # *WARNING*: it does not persist the created object.
  # 
  # @param [Hash] attr_hash the hash that contains the new MemberPost's values
  # @return [MemberPost] the created post object
  def self.create_from_params(attr_hash)
    post = MemberPost.new attr_hash.except("permissions_attributes")
    if attr_hash["permissions_attributes"]
      attr_hash["permissions_attributes"].each do |key, value|
        next if value["_destroy"] == true
        permissions = []
        perm = Permission.new value.except("_destroy")
        perm.abilities.reject! { |e| e.empty? }
        
        # skip permissions where there is no ability specified
        next if perm.abilities.size < 1

        if perm.manage.to_i != 0
          perm.ability = :manage
          permissions << perm
        elsif perm.abilities.size == 1
          perm.ability = perm.abilities[0]
          permissions << perm
        else
          perm.abilities.each { |a| permissions << Permission.new(:resource => perm.resource, :ability => a) }
        end
        MemberPost.uniq_perm(post, permissions).each do |p|
          post.permissions << p
        end
      end
    end

    post
  end

private
  
  # selects the unique permissions for the given MemberPost
  def self.uniq_perm(post, permissions)
    uniq = []
    permissions.each do |p|
      uniq << p if not post.permissions.any? { |pe| (p.resource == pe.resource && pe.ability == :manage) || ((p.resource == pe.resource) && (p.ability == pe.ability)) }
    end
    uniq
  end
end
