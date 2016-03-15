class RemoveTagRelatedTables < ActiveRecord::Migration
  def change
    drop_table :tag_links
    drop_table :tags
  end
end
