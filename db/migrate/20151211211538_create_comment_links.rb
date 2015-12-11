class CreateCommentLinks < ActiveRecord::Migration
  def change
    create_table :comment_links do |t|
      t.integer :comment_id
      t.integer :user_id
      t.boolean :agree

      t.timestamps
    end
  end
end
