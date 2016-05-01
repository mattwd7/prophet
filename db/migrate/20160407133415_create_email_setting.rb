class CreateEmailSetting < ActiveRecord::Migration
  def change
    create_table :mailer_settings do |t|
      t.integer :user_id
      t.string  :name
      t.boolean :active?

      t.timestamps
    end
    User.all.each do |u|
	  MailerSetting::DEFAULT_SETTINGS.each do |m|
	    mail = MailerSetting.new(m)
	    mail.user = u
	    mail.save
	  end
	end
  end
end
