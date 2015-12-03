class CreateFeedbackLinks < ActiveRecord::Migration
  def change
    create_table :feedback_links do |t|
      t.integer :feedback_id
      t.integer :user_id
      t.boolean :agree

      t.timestamps
    end
  end
end
