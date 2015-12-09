class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :feedbacks
  has_many :feedback_links

  def authored_feedbacks
    Feedback.where(author_id: self.id)
  end

end