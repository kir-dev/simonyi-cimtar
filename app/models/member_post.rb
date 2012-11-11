class MemberPost < ActiveRecord::Base
  #attr_accessible :from, :group_id, :member_id, :post_id, :to
  attr_accessible :group_id, :member_id, :post_id, :from_date, :to_date
end
