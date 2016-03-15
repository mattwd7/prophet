class Comment < ActiveRecord::Base
  include Scoreable

  belongs_to :user
  belongs_to :feedback
  has_many :notifications
  has_many :comment_links
  has_many :peers, through: :comment_links, source: :user

  validates_presence_of :content, :user_id, :feedback_id
  after_create :create_links, :create_notifications

  def author; user end

  def peers_in_agreement
    User.joins(:comment_links).where("comment_links.comment_id = ? and agree = ?", id, true)
  end

  def fresh?(user)
    notifications.where(user: user).any?
  end

private
  def create_links
    [feedback.peers, feedback.author].flatten.each do |peer|
      CommentLink.create(user: peer, comment: self) if peer != self.user
    end
  end

  def create_notifications
    [self.feedback.peers, self.feedback.author, self.feedback.user].flatten.reject{|u| u == self.user}.each do |user|
      Notification.create(feedback: self.feedback, user: user, comment: self)
    end
  end

end