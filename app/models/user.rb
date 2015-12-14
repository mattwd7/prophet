class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_many :feedbacks
  has_many :feedback_links
  has_many :comments
  has_many :comment_links

  validates_presence_of :email
  before_save :make_proper, :generate_user_tag


  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

  def is_peer?(feedback)
    FeedbackLink.where(feedback: feedback, user: self).count > 0
  end

  def agrees_with(feedback)
    feedback_links.where(feedback: feedback).first.try(:agree) || self == feedback.author
  end

private
  def make_proper
    first_name.try(:capitalize!)
    last_name.try(:capitalize!)
  end

  def generate_user_tag
    unless self.id
      tag = '@' + self.first_name + self.last_name
      existing_tags_count = User.where("user_tag LIKE '#{tag}%'").count
      if existing_tags_count > 0
        tag += "-#{existing_tags_count.to_s}"
      end
      self.user_tag = tag
    end
  end

end