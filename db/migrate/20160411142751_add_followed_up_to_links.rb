class AddFollowedUpToLinks < ActiveRecord::Migration
  def change
    add_column :feedback_links, :followed_up?, :boolean, null: false, default: false
  end
end
