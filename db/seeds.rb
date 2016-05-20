Organization.create!([
   {name: "Prophet LLC"}
])
User.create!([
  {email: "seb@symbiotic.com", first_name: "Sebastian", last_name: "Cardoso", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 3, current_sign_in_at: "2016-05-20 22:20:59", last_sign_in_at: "2016-05-20 04:18:41", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@SebastianCardoso", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Founder", type: "Admin", organization_id: 1},
  {email: "engineer1@symbiotic.com", first_name: "Engineer", last_name: "One", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-05-20 22:32:51", last_sign_in_at: "2016-05-20 22:32:51", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@EngineerOne", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Engineer", type: "", organization_id: 1},
  {email: "engineer2@symbiotic.com", first_name: "Engineer", last_name: "Two", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-05-20 22:36:10", last_sign_in_at: "2016-05-20 22:36:10", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@EngineerTwo", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Engineer", type: "", organization_id: 1},
  {email: "engineer3@symbiotic.com", first_name: "Paul", last_name: "Bellezza", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 2, current_sign_in_at: "2016-05-20 22:38:50", last_sign_in_at: "2016-05-20 22:38:39", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@PaulBellezza", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Engineer", type: "", organization_id: 1},
  {email: "artist@symbiotic.com", first_name: "Robin", last_name: "Mayne", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-05-20 22:21:55", last_sign_in_at: "2016-05-20 22:21:55", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@RobinMayne", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Artist", type: "", organization_id: 1},
  {email: "designer@symbiotic.com", first_name: "Thomas", last_name: "Vu", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-05-20 22:39:12", last_sign_in_at: "2016-05-20 22:39:12", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@ThomasVu", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: nil, title: "Designer", type: "", organization_id: 1}
])
Feedback.create!([
   {user_id: 6, author_id: 1, content: "The team and I are having constant issues with your ability to communicate clearly in Slack. We often have to ping threads with you because we are unsure of whether or not you've acknowledged the information in them. Going forward, it would be great if you could work on being more reactive to members of the team that are reaching out to you via Slack or other channels.", resonance_value: 1, followed_up: false, merged: false, merge_ids: nil},
   {user_id: 6, author_id: 1, content: "You're lack of engagement during the call with the design candidate this morning was troubling. Is there anything on your mind you'd like to talk about?", resonance_value: 2, followed_up: false, merged: false, merge_ids: nil},
   {user_id: 5, author_id: 5, content: "I feel like my latest rendering of the Symbiotic Splash art wasn't that great...what do you guys think?", resonance_value: 1, followed_up: false, merged: false, merge_ids: nil},
   {user_id: 6, author_id: 5, content: "I noticed that you constantly exaggerate the truth when Seb is around. For example, when he walked by our desks the other day you claimed that you and I review artwork every single day which is a flat out lie. I encourage you to be more honest with our supervisors because it fosters distrust when others observe you not being 100% truthful.", resonance_value: 0, followed_up: false, merged: false, merge_ids: nil},
   {user_id: 6, author_id: 2, content: "Your design concepts for the latest dungeon seemed really weak and not thoroughly thought out. Overall, seems like you've been pretty disengaged recently. Are we being clear enough about our expectations?", resonance_value: 0, followed_up: false, merged: false, merge_ids: nil},
   {user_id: 1, author_id: 3, content: "Thanks for getting me onboarded with the team. It's been a pretty smooth process so far and I'm excited to be here.", resonance_value: 0, followed_up: false, merged: false, merge_ids: nil}
])
Comment.create!([
  {content: "Hey guys -\r\n\r\nI'm also adding some other folks to this thread who were also on the call this morning. ", user_id: 5, feedback_id: 2},
  {content: "I also have this issue when I communicate with you, Thomas. Definitely would be great if you could be more reactive going forward - let us know how we can help.", user_id: 5, feedback_id: 1},
  {content: "Agreed. Let me know how I can be clearer about this expectation I have.", user_id: 2, feedback_id: 1},
  {content: "Yeah, this one wasn't up to your usual standards. Do you want to meet about it in person? It's hard for me to articulate in writing why I didn't like it.", user_id: 2, feedback_id: 3},
  {content: "Agreed - it seemed like you were totally zoned out. Something going on you want to tell us about? What can we do to help?", user_id: 2, feedback_id: 2},
  {content: "I just joined so I can't really weigh in on this, but let me know how I can help.", user_id: 3, feedback_id: 1},
  {content: "I agree it lacked polish.", user_id: 3, feedback_id: 3},
  {content: "I wasn't there so I can't really offer an opinion.", user_id: 3, feedback_id: 2}
])
FeedbackLink.create!([
  {feedback_id: 1, user_id: 1, agree: true, followed_up: false},
  {feedback_id: 1, user_id: 2, agree: true, followed_up: false},
  {feedback_id: 1, user_id: 3, agree: nil, followed_up: false},
  {feedback_id: 1, user_id: 4, agree: nil, followed_up: false},
  {feedback_id: 1, user_id: 5, agree: nil, followed_up: false},
  {feedback_id: 2, user_id: 1, agree: true, followed_up: false},
  {feedback_id: 2, user_id: 5, agree: true, followed_up: false},
  {feedback_id: 3, user_id: 5, agree: true, followed_up: false},
  {feedback_id: 3, user_id: 1, agree: nil, followed_up: false},
  {feedback_id: 3, user_id: 2, agree: true, followed_up: false},
  {feedback_id: 3, user_id: 3, agree: true, followed_up: false},
  {feedback_id: 3, user_id: 4, agree: nil, followed_up: false},
  {feedback_id: 3, user_id: 6, agree: nil, followed_up: false},
  {feedback_id: 2, user_id: 2, agree: true, followed_up: false},
  {feedback_id: 2, user_id: 3, agree: nil, followed_up: false},
  {feedback_id: 4, user_id: 5, agree: true, followed_up: false},
  {feedback_id: 5, user_id: 2, agree: true, followed_up: false},
  {feedback_id: 5, user_id: 3, agree: nil, followed_up: false},
  {feedback_id: 5, user_id: 4, agree: nil, followed_up: false},
  {feedback_id: 6, user_id: 3, agree: true, followed_up: false}
])
Log.create!([
  {user_id: 5, feedback_id: 2, content: "Robin Mayne added Engineer One and Engineer Two", type: "ShareLog"}
])
# MailerSetting.create!([
#   {user_id: 1, name: "new_feedback", active: true},
#   {user_id: 1, name: "new_comment", active: false},
#   {user_id: 1, name: "follow_up", active: true},
#   {user_id: 1, name: "feedback_resonates", active: false},
#   {user_id: 2, name: "new_feedback", active: true},
#   {user_id: 2, name: "new_comment", active: false},
#   {user_id: 2, name: "follow_up", active: true},
#   {user_id: 2, name: "feedback_resonates", active: false},
#   {user_id: 3, name: "new_feedback", active: true},
#   {user_id: 3, name: "new_comment", active: false},
#   {user_id: 3, name: "follow_up", active: true},
#   {user_id: 3, name: "feedback_resonates", active: false},
#   {user_id: 4, name: "new_feedback", active: true},
#   {user_id: 4, name: "new_comment", active: false},
#   {user_id: 4, name: "follow_up", active: true},
#   {user_id: 4, name: "feedback_resonates", active: false},
#   {user_id: 5, name: "new_feedback", active: true},
#   {user_id: 5, name: "new_comment", active: false},
#   {user_id: 5, name: "follow_up", active: true},
#   {user_id: 5, name: "feedback_resonates", active: false},
#   {user_id: 6, name: "new_feedback", active: true},
#   {user_id: 6, name: "new_comment", active: false},
#   {user_id: 6, name: "follow_up", active: true},
#   {user_id: 6, name: "feedback_resonates", active: false}
# ])
# Notification.create!([
#   {user_id: 4, feedback_id: 1, comment_id: nil},
#   {user_id: 1, feedback_id: 2, comment_id: 1},
#   {user_id: 1, feedback_id: 2, comment_id: 1},
#   {user_id: 1, feedback_id: 1, comment_id: 2},
#   {user_id: 4, feedback_id: 1, comment_id: 2},
#   {user_id: 1, feedback_id: 1, comment_id: 2},
#   {user_id: 1, feedback_id: 3, comment_id: nil},
#   {user_id: 6, feedback_id: 4, comment_id: nil},
#   {user_id: 1, feedback_id: 1, comment_id: 3},
#   {user_id: 4, feedback_id: 1, comment_id: 3},
#   {user_id: 5, feedback_id: 1, comment_id: 3},
#   {user_id: 1, feedback_id: 1, comment_id: 3},
#   {user_id: 5, feedback_id: 3, comment_id: 4},
#   {user_id: 1, feedback_id: 3, comment_id: 4},
#   {user_id: 5, feedback_id: 3, comment_id: 4},
#   {user_id: 5, feedback_id: 3, comment_id: 4},
#   {user_id: 1, feedback_id: 2, comment_id: 5},
#   {user_id: 5, feedback_id: 2, comment_id: 5},
#   {user_id: 1, feedback_id: 2, comment_id: 5},
#   {user_id: 4, feedback_id: 5, comment_id: nil},
#   {user_id: 1, feedback_id: 1, comment_id: 6},
#   {user_id: 2, feedback_id: 1, comment_id: 6},
#   {user_id: 4, feedback_id: 1, comment_id: 6},
#   {user_id: 5, feedback_id: 1, comment_id: 6},
#   {user_id: 1, feedback_id: 1, comment_id: 6},
#   {user_id: 5, feedback_id: 3, comment_id: 7},
#   {user_id: 1, feedback_id: 3, comment_id: 7},
#   {user_id: 2, feedback_id: 3, comment_id: 7},
#   {user_id: 5, feedback_id: 3, comment_id: 7},
#   {user_id: 5, feedback_id: 3, comment_id: 7},
#   {user_id: 1, feedback_id: 2, comment_id: 8},
#   {user_id: 5, feedback_id: 2, comment_id: 8},
#   {user_id: 2, feedback_id: 2, comment_id: 8},
#   {user_id: 1, feedback_id: 2, comment_id: 8},
#   {user_id: 1, feedback_id: 6, comment_id: nil}
# ])
# ShareLog.create!([
#   {user_id: 5, feedback_id: 2, content: "Robin Mayne added Engineer One and Engineer Two", type: "ShareLog"}
# ])
