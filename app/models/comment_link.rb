class CommentLink < ActiveRecord::Base

  belongs_to :comment
  belongs_to :user

  validates_presence_of :comment_id, :user_id

end