class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :feedbacks
  has_many :feedback_links

  before_save :make_proper, :generate_user_tag


  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

private
  def make_proper
    first_name.capitalize!
    last_name.capitalize!
  end

  def generate_user_tag
    tag = '@' + self.first_name + self.last_name
    existing_tags_count = User.where("user_tag LIKE '#{tag}%'").count
    if existing_tags_count > 0
      tag += "-#{existing_tags_count.to_s}"
    end
    self.user_tag = tag
  end

end