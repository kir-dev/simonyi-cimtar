class Post < ActiveRecord::Base
  belongs_to :membership
  attr_accessor :old_post # bool, transient attribute, used when saving post from the past

  attr_accessible :from, :title, :to, :old_post

  validates :title, :from, :presence => true

  validates_date :from,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.current }

  validates_date :to,
                 :on_or_after => :from,
                 :on_or_before => lambda { Date.current },
                 :allow_nil => true

  scope :active, where(:to => nil)

end
