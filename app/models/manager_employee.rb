class ManagerEmployee < ActiveRecord::Base

  belongs_to :employee, class_name: 'User'
  belongs_to :manager, class_name: 'User'

end