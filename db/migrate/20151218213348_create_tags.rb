class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :tag_links do |t|
      t.integer :tag_id
      t.integer :feedback_id

      t.timestamps
    end
  end
end
