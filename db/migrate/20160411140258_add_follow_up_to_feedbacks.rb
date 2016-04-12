class AddFollowUpToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :followed_up?, :boolean, null: false, default: false
  end
end
