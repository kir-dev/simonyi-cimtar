# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  can_create  :boolean          default(FALSE)
#  can_read    :boolean          default(FALSE)
#  can_update  :boolean          default(FALSE)
#  can_destroy :boolean          default(FALSE)
#  resource    :string(255)
#  post_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Permission < ActiveRecord::Base
  ABILITIES = [:create, :read, :update, :destroy].freeze


  belongs_to :post, :class_name => "MemberPost"
  attr_accessible :can_create, :can_read, :can_update, :can_destroy, :resource

  validates :resource, :presence => true
  validates :can_create, :can_read, :can_update, :can_destroy, :inclusion => { :in => [true, false] }

  # returns an array containing all the abilities that the permission has
  def abilities
    abilities = []
    abilities << :create if can_create?
    abilities << :read if can_read?
    abilities << :update if can_update?
    abilities << :destroy if can_destroy?
    abilities << :manage if manage?
    abilities
  end

  # convinience method for setting all the abilities at once
  # 
  # @param value [Array] the array containing the abilities to set
  def abilities=(value)
    value = value.dup
    self.can_create  = !!value.delete(:create)
    self.can_read    = !!value.delete(:read)
    self.can_update  = !!value.delete(:update)
    self.can_destroy = !!value.delete(:destroy)
    nil
  end

  # returns true if the permission has all the available abilities
  def manage?
    can_create? && can_read? && can_update? && can_destroy?
  end

  alias_method :manage, :manage?

  def manage=(value)
    value_as_int = value.respond_to?(:to_i) ? value.to_i : 0 
    if value == true || !value_as_int.zero?
      self.abilities = ABILITIES
    else
      self.abilities = []
    end
    nil
  end
end
