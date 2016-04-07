class CreateEmailSetting < ActiveRecord::Migration
  def change
    create_table :mailer_settings do |t|
      t.integer :user_id
      t.string  :name
      t.boolean :active?

      t.timestamps
    end
  end
end
