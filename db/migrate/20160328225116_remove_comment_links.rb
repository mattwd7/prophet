class RemoveCommentLinks < ActiveRecord::Migration
  def change
    drop_table :comment_links
  end
end
