class Feedback < ActiveRecord::Base

  belongs_to :user
  has_many :comments
  has_many :feedback_links
  has_many :participants, through: :feedback_links, source: :user

  validates_presence_of :user_id, :author_id, :content

  def author
    User.find(author_id)
  end

  def author=(value)
    value = value.try(:id) || value
    write_attribute(:author_id, value)
  end

  def participants_in_agreement
    User.joins(:feedback_links).where("feedback_links.feedback_id = ? and agree = ?", id, true)
  end

end