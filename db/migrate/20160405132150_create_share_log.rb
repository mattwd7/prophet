class CreateShareLog < ActiveRecord::Migration
  def change
    create_table :share_logs do |t|
      t.integer :user_id
      t.integer :feedback_id
      t.string :names

      t.timestamps
    end
  end
end
