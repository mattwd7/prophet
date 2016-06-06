class Notifier < Devise::Mailer
  # layout 'email'
  default from: "Prophet Team <no-reply@prophet.com>"

  def new_user(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Welcome to Prophet!', )
  end

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
    feedback.user.mail_logs.create(feedback: feedback, content: feedback.resonance_value + 1)
    mail(to: feedback.user.email, subject: 'Your feedback is resonating with your peers.')
  end

private
  def mail(headers={}, &block)
    headers[:to] = 'prophet.mailer1@gmail.com' # for all testing purposes

    super(headers, &block)
  end

end