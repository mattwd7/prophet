class Manager < User

  has_many :manager_employees, foreign_key: 'manager_id'
  has_many :employees, through: :manager_employees

  def add_employee(user)
    ManagerEmployee.create(employee_id: user.id, manager_id: self.id)
  end

  def remove_employee(user)
    ManagerEmployee.where(employee: user, manager: self).first.destroy
  end

end