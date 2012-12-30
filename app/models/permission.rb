class Permission < ActiveRecord::Base
  VALID_ABILITIES = %w( read create update destroy manage ).map(&:to_sym).freeze

  belongs_to :post, :class_name => "MemberPost"
  attr_accessible :ability, :resource

  validates :ability, :resource, :presence => true
  validates :ability, :inclusion => { :in => VALID_ABILITIES }


  def ability
    super.try :to_sym
  end

  def ability=(value)
    super(value.to_sym)
    ability
  end

end
