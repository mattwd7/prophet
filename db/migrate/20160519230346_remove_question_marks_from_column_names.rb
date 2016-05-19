class RemoveQuestionMarksFromColumnNames < ActiveRecord::Migration
  def change
    remove_index :feedbacks, :merged?
    rename_column :feedbacks, :merged?, :merged
    rename_column :mailer_settings, :active?, :active
  end
end
