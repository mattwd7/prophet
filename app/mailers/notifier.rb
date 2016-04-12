class Notifier < ActionMailer::Base
  # layout 'email'
  default from: "Prophet Team <no-reply@prophet.com>"

  def new_feedback(feedback)
    mail(to: feedback.user.email, subject: 'You have new feedback!')
  end

  def new_comment(feedback)
    mail(to: feedback.user.email, subject: 'Your feedback has received a new comment!')
  end

  def follow_up(feedback)
    mail(to: feedback.user.email, subject: 'Your peers have followed up on your feedback!')
  end

  def feedback_resonates(feedback)
    mail(to: feedback.user.email, subject: 'Your feedback is resonating with your peers.')
  end

end