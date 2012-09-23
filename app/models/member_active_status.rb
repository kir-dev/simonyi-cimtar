class MemberActiveStatus < ActiveRecord::Base
  attr_accessible :from, :group_id, :member_id, :to
end
