class Organization < ActiveRecord::Base

  has_many :users

  def admins
    users.where(type: 'Admin')
  end

  def managers
    users.where(type: 'Manager')
  end

  def spreadsheet_data
    users.map do |user|
      {
        first_name: user.first_name,
        last_name: user.last_name,
        user_tag: user.user_tag,
        email: user.email,
        manager: user.managers.first.try(:full_name)
      }
    end
  end


end