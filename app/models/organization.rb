class Organization < ActiveRecord::Base

  has_many :users

  def admins
    users.where(type: 'Admin')
  end

  def managers
    users.where(type: 'Manager').map{|u| u.attributes.merge({full_name: u.full_name})}
  end

  def spreadsheet_data
    users.map do |user|
      manager_hash = { managers: user.managers.map(&:full_name).join(', ') }
      role_hash = { role: user.type || '' }
      user.attributes.merge(manager_hash).merge(role_hash)
    end
  end

end