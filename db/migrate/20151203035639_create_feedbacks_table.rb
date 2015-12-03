class CreateFeedbacksTable < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :author_id
      t.string :content

      t.timestamps
    end
  end
end
