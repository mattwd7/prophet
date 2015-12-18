class TagLink < ActiveRecord::Base

  attr_accessor :tag_name
  belongs_to :feedback
  belongs_to :tag

  before_validation :create_missing_tag
  validates_uniqueness_of :tag_id, scope: :feedback_id


private
  def create_missing_tag
    self.tag = Tag.find_or_create_by_name(self.tag_name)
  end

end