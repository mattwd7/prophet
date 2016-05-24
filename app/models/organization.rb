class Organization < ActiveRecord::Base

  has_many :users
  has_many :admins

  def managers
    users.where(type: ['Manager', 'Admin'])
  end

  def spreadsheet_data
    users.map do |user|
      manager_hash = { managers: user.managers.map(&:full_name).join(', ') }
      role_hash = { role: user.type || '' }
      user.attributes.merge(manager_hash).merge(role_hash).inject({}){|out, (k, v)| out[k] = (v || ""); out}
    end
  end

end