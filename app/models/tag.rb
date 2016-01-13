class Tag < ActiveRecord::Base

  has_many :tag_links
  has_many :feedbacks, through: :tag_links
  validates_uniqueness_of :name

  def self.find_or_create_by_name(tag_name)
    if Tag.find_by_name(tag_name).present?
      Tag.find_by_name(tag_name)
    else
      Tag.create(name: tag_name)
    end
  end

end