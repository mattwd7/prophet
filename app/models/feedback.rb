class Feedback < ActiveRecord::Base
  include Scoreable

  belongs_to :user
  has_many :comments
  has_many :feedback_links
  has_many :peers, through: :feedback_links, source: :user
  has_many :tag_links
  has_many :tags, through: :tag_links
  has_many :notifications

  validates_presence_of :author_id
  validates_presence_of :user_id, message: 'Feedback must begin with a valid user tag.'
  validates_presence_of :content, message: 'Feedback must have content.'
  before_validation :parse_recipient
  after_create :parse_tags, :create_notification

  scope :resonant, -> { where(resonance_value: 2) }
  scope :mixed, -> { where(resonance_value: 1) }
  scope :isolated, -> { where(resonance_value: 0) }

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

  def assign_peers(peer_tags)
    peer_tags.each do |peer_tag|
      user = User.find_by_user_tag(peer_tag)
      FeedbackLink.create(feedback: self, user: user)
    end

    self.comments.each do |comment|
      CommentLink.create(comment: comment, user: user)
    end
  end

  def add_tag(tag_name)
    TagLink.create(tag_name: tag_name, feedback: self)
  end

private
  def parse_tags
    content.scan(/#\S+/).uniq.each do |tag_name|
      add_tag(tag_name)
    end
  end

  def parse_recipient
    user_tag = content.scan(/@\S+/).uniq.first
    self.user ||= User.find_by_user_tag(user_tag)
    self.content = self.content.sub(user_tag, '').strip if user_tag
  end

  def create_notification
    Notification.create(feedback: self, user: self.user)
  end

end