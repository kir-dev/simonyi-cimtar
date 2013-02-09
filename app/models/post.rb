class Post < ActiveRecord::Base
  belongs_to :membership
  attr_accessible :from, :title, :to
end
