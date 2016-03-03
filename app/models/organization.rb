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
      manager_hash = { managers: user.managers.map(&:full_name).join(', ') }
      user.attributes.merge(manager_hash)
    end
  end

end