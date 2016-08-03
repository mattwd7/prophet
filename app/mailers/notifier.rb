class Notifier < Devise::Mailer
  helper ApplicationHelper
  helper FeedbacksHelper
  default from: "Prophet Team <no-reply@prophet.com>"

  def new_user(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Welcome to Prophet!')
  end

  def new_feedback(feedback)
    @feedback = feedback
    mail(to: feedback.user.email, subject: 'You have new feedback!')
  end

  def new_comment(feedback, comment)
    @feedback = feedback
    @comment = comment
    mail(to: feedback.user.email, subject: 'Your feedback has received a new comment!')
  end

  def follow_up(feedback)
    @feedback = feedback
    mail(to: feedback.user.email, subject: 'Your peers have followed up on your feedback!')
  end

  def feedback_resonates(feedback)
    @feedback = feedback
    feedback.user.mail_logs.create(feedback: feedback, content: feedback.resonance_value + 1)
    mail(to: feedback.user.email, subject: 'Your feedback is resonating with your peers.')
  end

private
  def mail(headers={}, &block)
    headers[:to] = 'prophet.mailer1@gmail.com' unless Rails.env.production? # for all testing purposes
    headers[:content_type] = 'text/html'

    super(headers, &block)
  end

end