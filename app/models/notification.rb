class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feedback
  belongs_to :comment

end