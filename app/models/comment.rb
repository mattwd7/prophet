class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedback

  validates_presence_of :content, :user_id, :feedback_id
end