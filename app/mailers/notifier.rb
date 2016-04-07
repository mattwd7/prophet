class Notifier < ActionMailer::Base
  # layout 'email'

  def new_feedback(feedback)
    mail(to: feedback.user.email, from: feedback.author.email, subject: 'You have new feedback!')
  end

end