class ManagerEmployee < ActiveRecord::Base

  belongs_to :employee, class_name: 'User'
  belongs_to :manager, class_name: 'User'

  validates_uniqueness_of :manager_id, scope: :employee_id
  validate :non_self_management


private
  def non_self_management
    errors.add('Manager cannot manage him or her self') if employee_id == manager_id
  end

end