class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback
  has_many :comment_links
  has_many :peers, through: :comment_links, source: :user

  validates_presence_of :content, :user_id, :feedback_id
  after_create :create_links

  def author
    user
  end

  def peers_in_agreement
    User.joins(:comment_links).where("comment_links.comment_id = ? and agree = ?", id, true)
  end

private
  def create_links
    [feedback.author, feedback.peers].flatten.each do |peer|
      CommentLink.create(user: peer, comment: self) if peer != self.user
    end
  end

end