class InternalMail < ActionMailer::Base
  # layout 'email'
  default to: "mattwd7@gmail.com"

  def registration_request(email)
    mail(from: email, subject: 'New Prophet Registration Request')
  end

end