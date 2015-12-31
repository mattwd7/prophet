class Feedback < ActiveRecord::Base
  include Scoreable

  belongs_to :user
  has_many :comments
  has_many :feedback_links
  has_many :peers, through: :feedback_links, source: :user
  has_many :tag_links
  has_many :tags, through: :tag_links

  validates_presence_of :user_id, :author_id, :content
  after_create :parse_tags

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

end