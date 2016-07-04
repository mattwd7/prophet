class FeedbackLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback

  validates :user_id, uniqueness: { scope: :feedback_id }
  after_save :update_feedback_resonance
  after_create :create_notification

private
  def update_feedback_resonance
    new_resonance_value = feedback.calc_resonance_value
    if new_resonance_value > feedback.resonance_value && new_resonance_value > 0
      feedback.create_notification
      send_email unless feedback.user.mail_logs.where(feedback: feedback, content: new_resonance_value.to_s).exists?
    end
    feedback.update_attributes(resonance_value: new_resonance_value)
  end

  def create_notification
    Notification.create(feedback: feedback, user: user) unless feedback.author == user
  end

  def send_email
    Notifier.feedback_resonates(self.feedback).deliver if feedback.user.mailer_settings.for('feedback_resonates').active?
  end

end