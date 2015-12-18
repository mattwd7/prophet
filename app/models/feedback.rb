class Feedback < ActiveRecord::Base

  belongs_to :user
  has_many :comments
  has_many :feedback_links
  has_many :peers, through: :feedback_links, source: :user

  validates_presence_of :user_id, :author_id, :content

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

end