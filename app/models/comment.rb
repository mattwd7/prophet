class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback
  has_many :comment_links
  has_many :peers, through: :comment_links, source: :user

  validates_presence_of :content, :user_id, :feedback_id

  def peers_in_agreement
    User.joins(:comment_links).where("comment_links.comment_id = ? and agree = ?", id, true)
  end


end