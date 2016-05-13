class Feedback < ActiveRecord::Base
  include Scoreable

  belongs_to :user
  has_many :comments
  has_many :feedback_links
  has_many :peers, through: :feedback_links, source: :user
  has_many :notifications
  has_many :logs

  validates_presence_of :author_id
  validates_presence_of :user_id, message: 'Feedback must start with a valid user tag from the dropdown list.'
  validates_presence_of :content, message: 'Feedback content cannot be blank.'

  before_validation :parse_recipient
  before_save :set_defaults
  after_create :set_author_as_peer, :create_notification, :send_email

  default_scope { where(merged?: false) }
  scope :resonant, -> { where(resonance_value: 2) }
  scope :mixed, -> { where(resonance_value: 1) }
  scope :isolated, -> { where(resonance_value: 0) }
  self.per_page = 10

  def author
    User.find(author_id)
  end

  def author=(value)
    value = value.try(:id) || value
    write_attribute(:author_id, value)
  end

  def peers_in_agreement
    User.joins(:feedback_links).where("feedback_links.feedback_id = ? and agree = ?", id, true)
  end

  def create_peer_links(peer_tags, assigner=nil)
    names = []
    peer_tags.each do |peer_tag|
      user = User.find_by_user_tag(peer_tag)
      names << user.full_name
      FeedbackLink.create(feedback: self, user: user)
    end
    self.logs.create(type: "ShareLog", user: assigner, names: names) if assigner
  end

  def fresh_comments(user)
    comments.joins(:notifications).where("notifications.user_id = ?", user.id).group("comments.id")
  end

  def comment_history
   (comments + logs).sort{|a,b| a.created_at <=> b.created_at }
  end

  def create_notification
    Notification.create(feedback: self, user: self.user) unless self.user == self.author
  end

  def follow_up
    update_attributes(followed_up: true)
    Notification.create(user: user, feedback: self)
  end

private
  def set_defaults
    self.resonance_value ||= 0
  end

  def set_author_as_peer
    FeedbackLink.create(feedback: self, user: self.author, agree: true)
  end

  def parse_recipient
    user_tag = content.scan(/@\S+/).uniq.first
    self.user ||= User.find_by_user_tag(user_tag)
    self.content = self.content.sub(user_tag, '').strip if user_tag
  end

  def send_email
    Notifier.new_feedback(self).deliver if user.mailer_settings.for('new_feedback').active? && self.user != self.author
  end
end