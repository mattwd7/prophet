class Organization < ActiveRecord::Base

  has_many :users

  def admins
    users.where(type: 'Admin')
  end

  def managers
    users.where(type: 'Manager')
  end


end