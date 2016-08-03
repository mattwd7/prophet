class NotifierPreview < ActionMailer::Preview

  def new_feedback
    @feedback = Feedback.last
    Notifier.new_feedback(@feedback)
  end

  def new_user
    @user = User.last
    @password = 'xyz123'
    Notifier.new_user(@user, @password)
  end

  def new_comment
    @feedback = Feedback.joins(:comments).last
    @comment = @feedback.comments.last
    Notifier.new_comment(@feedback, @comment)
  end

  def follow_up
    @feedback = Feedback.last
    Notifier.follow_up(@feedback)
  end

  def feedback_resonates
    @feedback = Feedback.last
    Notifier.feedback_resonates(@feedback)
  end

end