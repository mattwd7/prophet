class User < ActiveRecord::Base
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { small: "100x100#", large: "500x500>" }, processors: [:cropper]
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_many :feedbacks
  has_many :feedback_links
  has_many :comments
  has_many :comment_links

  validates_presence_of :email
  before_save :make_proper, :generate_user_tag

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    if avatar.path(style)
      @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
    else
      @geometry[style] = OpenStruct.new(width: 0, height: 0)
    end
  end

  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

  def peers
    User.where.not(id: self.id)
  end

  def is_peer?(feedback_or_comment)
    if feedback_or_comment.instance_of?(Feedback)
      FeedbackLink.where(feedback: feedback_or_comment, user: self).count > 0
    else
      CommentLink.where(comment: feedback_or_comment, user: self).count > 0
    end
  end

  def agrees_with(feedback_or_comment)
    if feedback_or_comment.instance_of?(Feedback)
      feedback_links.where(feedback: feedback_or_comment).first.try(:agree) || self == feedback_or_comment.author
    else
      comment_links.where(comment: feedback_or_comment).first.try(:agree) || self == feedback_or_comment.author
    end
  end

private
  def reprocess_avatar
    avatar.reprocess!
  end

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