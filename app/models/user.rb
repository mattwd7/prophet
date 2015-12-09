class User < ActiveRecord::Base

  has_many :feedbacks
  has_many :feedback_links

  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

end