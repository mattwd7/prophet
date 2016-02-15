class CreateManagerEmployees < ActiveRecord::Migration
  def change
    create_table :manager_employees do |t|
      t.integer :employee_id
      t.integer :manager_id

      t.timestamps
    end
  end
end
