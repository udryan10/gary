class Schedule < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user

  def self.update_posting(id, posting)
    schedule = Schedule.find(id)
    schedule.posting = posting
    schedule.save
  end
end
