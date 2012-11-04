class JobPosition < ActiveRecord::Base
  attr_accessible :company, :location, :title, :from_date, :to_date, :present_job

  belongs_to :member

  validates :company, :title, :location, :length => {:minimum => 3, :maximum => 200}

  validates_date :from_date, :on_or_after => lambda { Date.new(1990, 1, 1) }
  validates_date :from_date, :on_or_before => lambda { Date.new(2025, 12, 1) }

  #unless :present_job #??? TODO
  validates_date :to_date, :on_or_before => lambda { Date.new(2025, 12, 1) }
  validates_date :to_date, :on_or_before => lambda { Date.current }
  validates_date :to_date, :on_or_after => :from_date
end
