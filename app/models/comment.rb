class Comment < ActiveRecord::Base
  include Scoreable

  belongs_to :user
  belongs_to :feedback
  has_many :notifications
  has_many :comment_links
  has_many :peers, through: :comment_links, source: :user

  validates_presence_of :content, :user_id, :feedback_id
  after_create :create_notifications, :send_email

  def author; user end

  def fresh?(user)
    notifications.where(user: user).any?
  end

private
  def create_notifications
    [self.feedback.peers, self.feedback.author, self.feedback.user].flatten.reject{|u| u == self.user}.each do |user|
      Notification.create(feedback: self.feedback, user: user, comment: self)
    end
  end

  def send_email
    puts '!!!', 'sending email after comment creation', '!!!', feedback.user.mailer_settings.for('new_comment').active?
    Notifier.new_comment(self.feedback, self).deliver if feedback.user.mailer_settings.for('new_comment').active?
  end

end