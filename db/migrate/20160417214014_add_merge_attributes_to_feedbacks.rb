class AddMergeAttributesToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :merged?, :boolean, default: false
    add_column :feedbacks, :merge_ids, :string

    add_index :feedbacks, :merged?
  end
end
