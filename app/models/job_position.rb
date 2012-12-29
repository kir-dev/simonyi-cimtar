class JobPosition < ActiveRecord::Base
  attr_accessible :company, :location, :title, :from_date, :to_date, :present_job

  belongs_to :member

  validates :company, :title, :location, 
    :length => {:minimum => 3, :maximum => 200}, :presence => true

  validates_date :from_date,
                 :on_or_after => lambda { Date.new(1990, 1, 1) },
                 :on_or_before => lambda { Date.current }

  validate :either_to_date_or_present_job_must_be_present
  
private

  # validates the the to_date and present_job attributes at the same time
  # either of the must be present, in case it is to_date
  # it must be between today and from_date
  def either_to_date_or_present_job_must_be_present
    # present_job and to_date can't be blank at the same time
    if present_job.blank? && to_date.blank?
      # TODO:_ message i18n
      errors.add :present_job, "must be true when there is no to_date specified"
      return
    end

    # if present_job is true, to_date must be empty
    if present_job && to_date.present?
      # TODO:_ message i18n
      errors.add :to_date, "can't specify to_date when present_job is true"
    end

    # to_date should be between today's date and from_date
    if present_job.blank?
      if to_date > Date.today
        errors.add :to_date, "to_date must be before #{Date.today}"
      end
      if to_date < from_date
        errors.add :to_date, "to_date must be after #{self.from_date}"
      end
    end
  end
end
