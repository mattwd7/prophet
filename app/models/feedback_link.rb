class FeedbackLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback

  after_save :update_feedback_resonance

private
  def update_feedback_resonance
    feedback.update_attributes(resonance_value: feedback.calc_resonance_value)
  end

end