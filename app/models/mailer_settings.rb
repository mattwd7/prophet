class MailerSetting < ActiveRecord::Base

  belongs_to :user

  DEFAULT_SETTINGS = [{name: 'new_feedback', active?: true},
                      {name: 'new_comment', active?: false},
                      {name: 'new_peer', active?: false},
                      {name: 'new_follow_up', active?: true}]

end