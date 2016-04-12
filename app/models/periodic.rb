class Periodic

  def self.follow_ups
    Feedback.where("created_at < ?", 30.days.ago).where(followed_up?: false).each do |feedback|
      feedback.follow_up
    end
  end

end