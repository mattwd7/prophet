class MailerSetting < ActiveRecord::Base

  belongs_to :user

  scope :for, -> (name) { where(name: name).first }

  DEFAULT_SETTINGS = [{name: 'new_feedback', active?: true},
                      {name: 'new_comment', active?: false},
                      {name: 'follow_up', active?: true},
                      {name: 'feedback_resonates', active?: false}]

end