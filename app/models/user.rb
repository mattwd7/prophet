class User < ActiveRecord::Base
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  STATIC_SCALES = {
      small: "100x100#",
      large: "350x350>"
  }

  has_attached_file :avatar, default_url: ":style/missing.png",
                    styles: { small: "100x100#", large: "350x350>" },
                    processors: [:cropper]
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  belongs_to :organization
  has_many :feedbacks
  has_many :feedback_links
  has_many :comments
  has_many :comment_links
  has_many :manager_employees, foreign_key: 'employee_id'
  has_many :managers, through: :manager_employees
  has_many :notifications
  has_many :share_logs
  has_many :mail_logs
  has_many :mailer_settings

  validates_presence_of :email
  before_save :make_proper, :generate_user_tag, :update_user_tag
  after_create :set_mailer_settings, :email_credentials

  def full_name
    first_name + ' ' + last_name
  end

  def home_feedbacks(resonance=nil, search=nil)
    query = Feedback.joins(:feedback_links).where("feedbacks.author_id = ? or feedback_links.user_id = ? or feedbacks.user_id = ?", self.id, self.id, self.id).order('feedbacks.updated_at DESC').group('feedbacks.id')
    apply_filter(query, resonance, search)
  end

  def my_feedbacks(resonance=nil, search=nil)
    query = Feedback.where("feedbacks.user_id = ?", self.id).order("updated_at DESC").group('feedbacks.id')
    apply_filter(query, resonance, search)
  end

  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

  def peers
    User.where.not(id: self.id)
  end

  def can_vote?(feedback)
    ![feedback.author, feedback.user].include?(self)
  end

  def agrees_with(feedback_or_comment)
    if feedback_or_comment.instance_of?(Feedback)
      feedback_links.where(feedback: feedback_or_comment).first.try(:agree) || self == feedback_or_comment.author
    else
      comment_links.where(comment: feedback_or_comment).first.try(:agree) || self == feedback_or_comment.author
    end
  end

  def my_notifications
    notifications.joins(:feedback).where("feedbacks.user_id = ? or feedbacks.author_id = ?", self.id, self.id).select("DISTINCT feedbacks.id")
  end

  def home_notifications
    notifications.joins(feedback: :feedback_links).where("feedback_links.user_id = ?", self.id).select("DISTINCT feedbacks.id")
  end

  def fresh_feedbacks
    Feedback.joins(:notifications).where('notifications.user_id = ?', self.id)
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    if avatar.path(style)
      @geometry[style] ||= Paperclip::Geometry.from_file(open(avatar.url(style)))
    else
      @geometry[style] = OpenStruct.new(width: 0, height: 0)
    end
  end

  def update_mailer_settings(params)
    if params
      mailer_settings.each do |setting|
        setting.update_attributes(active: !params[setting.name].nil?)
      end
    end
  end

  def following_up?(feedback)
    link = feedback_links.where(feedback: feedback).first
    if link
      feedback.followed_up? && !link.followed_up?
    end
  end

  def follow_up(feedback)
    link = feedback_links.where(feedback: feedback).first
    link.update_attributes(followed_up: true) if link
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
      self.user_tag = '@' + self.first_name.to_s + self.last_name.to_s
      last_tag = User.where("user_tag LIKE '#{user_tag}%'").sort.last.try(:user_tag)
      if last_tag
        last_tag_suffix = last_tag.match(/-\d+/)
        next_tag = last_tag_suffix ? last_tag_suffix[0].match(/\d+/)[0].to_i + 1 : 1
        self.user_tag += "-#{next_tag.to_s}"
      end
    end
  end

  def update_user_tag
    if self.first_name_changed? || self.last_name_changed?
      suffix = self.user_tag.match(/-\d+/)
      suffix = suffix ? suffix[0] : ''
      self.user_tag = '@' + self.first_name.to_s + self.last_name.to_s + suffix
    end
  end

  def apply_filter(base_query, resonance=nil, search=nil)
    if resonance && resonance.count > 0
      values = resonance.map{ |r| Scoreable::RESONANCE_TEXT.index(r) }
      base_query = base_query.where(resonance_value: values)
    end
    if search
      terms = search.split(' ').map{|term| "content like '%#{term}%'"}
      terms = terms.join(' and ')
      base_query = base_query.where(terms)
    end
    base_query
  end

  def set_mailer_settings
    MailerSetting::DEFAULT_SETTINGS.each do |setting|
      self.mailer_settings.create(setting)
    end
  end

  def email_credentials
    self.save # completes the creation cycle, allowing Devise to create a
    self.send_reset_password_instructions
  end

end