class ChangeFollowUpColumnName < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :followed_up?, :followed_up
    rename_column :feedback_links, :followed_up?, :followed_up
  end
end
