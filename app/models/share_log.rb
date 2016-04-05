class ShareLog < ActiveRecord::Base

  belongs_to :user
  belongs_to :feedback
  serialize :names, Array

end