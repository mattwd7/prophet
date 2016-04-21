class RenameShareLogToLog < ActiveRecord::Migration
  def change
    rename_table :share_logs, :logs
    add_column :logs, :type, :string
    rename_column :logs, :names, :content
  end
end
