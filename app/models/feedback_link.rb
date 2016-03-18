class FeedbackLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback

  validates :user_id, uniqueness: { scope: :feedback_id }
  after_save :update_feedback_resonance
  after_create :create_notification

private
  def update_feedback_resonance
    new_resonance_value = feedback.calc_resonance_value
    if new_resonance_value > feedback.resonance_value
      feedback.create_notification
    end
    feedback.update_attributes(resonance_value: feedback.calc_resonance_value)
  end

  def create_notification
    Notification.create(feedback: self.feedback, user: self.user)
  end

end