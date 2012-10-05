class Membership < ActiveRecord::Base
  #attr_accessible :from, :group_id, :member_id, :to
  attr_accessible :group_id, :member_id
end
