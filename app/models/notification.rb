class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feedback
  belongs_to :comment

  after_create :update_feedback

private
  def update_feedback
    feedback.update_attributes(updated_at: Time.now)
  end

end