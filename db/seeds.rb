User.create!([
  {email: "matt@gmail.com", first_name: "Matthew", last_name: "Dick", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 68, current_sign_in_at: "2016-03-26 22:04:15", last_sign_in_at: "2016-03-21 13:08:25", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@MatthewDick", avatar_file_name: "my_avatar.jpg", avatar_content_type: "image/jpeg", avatar_file_size: 291331, avatar_updated_at: "2015-12-18 06:27:10", bio: "Badass programmer, all day every day ;)", title: "Software Engineer", type: nil, organization_id: 1},
  {email: "tony@gmail.com", first_name: "Tony", last_name: "Decino", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 25, current_sign_in_at: "2016-03-28 13:46:09", last_sign_in_at: "2016-03-18 05:56:47", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@TonyDecino", avatar_file_name: "tony_avatar.jpg", avatar_content_type: "image/jpeg", avatar_file_size: 105745, avatar_updated_at: "2016-03-28 14:47:35", bio: "Tony D: Comp Masta", title: "Software Engineer", type: nil, organization_id: 1},
  {email: "user1@gmail.com", first_name: "User", last_name: "One", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 6, current_sign_in_at: "2016-03-18 05:42:12", last_sign_in_at: "2015-12-17 06:05:44", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@UserOne", avatar_file_name: "avatar_1.jpg", avatar_content_type: "image/jpeg", avatar_file_size: 74539, avatar_updated_at: "2015-12-17 06:06:07", bio: "I'm user one!", title: "Software Engineer", type: nil, organization_id: 1},
  {email: "user2@gmail.com", first_name: "User", last_name: "Two", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 3, current_sign_in_at: "2015-12-17 05:15:36", last_sign_in_at: "2015-12-11 23:20:48", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@UserTwo", avatar_file_name: "avatar_2.jpg", avatar_content_type: "image/jpeg", avatar_file_size: 435374, avatar_updated_at: "2015-12-17 05:15:53", bio: nil, title: "Software Engineer", type: nil, organization_id: 1},
  {email: "user3@gmail.com", first_name: "User", last_name: "Three", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 2, current_sign_in_at: "2015-12-17 05:16:04", last_sign_in_at: "2015-12-10 05:58:05", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@UserThree", avatar_file_name: "avatar_3.jpeg", avatar_content_type: "image/jpeg", avatar_file_size: 9967, avatar_updated_at: "2015-12-17 05:16:15", bio: nil, title: "Software Engineer", type: nil, organization_id: 1},
  {email: "manager@gmail.com", first_name: "Captain", last_name: "Manager", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 12, current_sign_in_at: "2016-03-19 01:16:13", last_sign_in_at: "2016-03-18 17:32:38", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@CaptainManager", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: "I'm managing all these homies", title: nil, type: "Manager", organization_id: 1},
  {email: "admin@gmail.com", first_name: "Admin", last_name: "Man", password: "password", password_confirmation: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 10, current_sign_in_at: "2016-03-18 21:07:49", last_sign_in_at: "2016-03-18 05:44:18", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@AdminMan", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: "I am the all ruling overlord!", title: nil, type: "Admin", organization_id: 1}
])
Comment.create!([
  {content: "I'm leaving this comment cause i feel passionate about this feedback", user_id: 5, feedback_id: 1},
  {content: "And I think you're doing a great job", user_id: 1, feedback_id: 5},
  {content: "Commenting on my own, recieved feedback", user_id: 1, feedback_id: 2},
  {content: "User1 has a comment as well", user_id: 3, feedback_id: 5},
  {content: "Thanks dude!", user_id: 2, feedback_id: 6},
  {content: "what?", user_id: 2, feedback_id: 6},
  {content: "Correct number of peers?", user_id: 2, feedback_id: 5},
  {content: "why are there 8?", user_id: 2, feedback_id: 5},
  {content: "but what about here?", user_id: 2, feedback_id: 9},
  {content: "Hey", user_id: 1, feedback_id: 10},
  {content: "sup with comments?", user_id: 1, feedback_id: 17},
  {content: "now?", user_id: 1, feedback_id: 17},
  {content: "comment peer count test", user_id: 1, feedback_id: 17},
  {content: "first comment", user_id: 1, feedback_id: 18},
  {content: "second comment", user_id: 1, feedback_id: 18},
  {content: "another comment", user_id: 1, feedback_id: 18},
  {content: "and another", user_id: 1, feedback_id: 18},
  {content: "no peers?", user_id: 1, feedback_id: 18},
  {content: "wtf..", user_id: 1, feedback_id: 18},
  {content: "well?", user_id: 1, feedback_id: 16},
  {content: "wtf...", user_id: 1, feedback_id: 16},
  {content: "sup", user_id: 1, feedback_id: 16},
  {content: "again", user_id: 1, feedback_id: 16},
  {content: "working?", user_id: 1, feedback_id: 19},
  {content: "nope", user_id: 1, feedback_id: 19},
  {content: "now it's working????", user_id: 1, feedback_id: 19},
  {content: "Yea you need to do better", user_id: 2, feedback_id: 9},
  {content: "great job #leadership", user_id: 1, feedback_id: 16},
  {content: "and also #bravery", user_id: 1, feedback_id: 16},
  {content: "i'm a baller #leadership", user_id: 1, feedback_id: 10},
  {content: "what are you looking at? #punk", user_id: 1, feedback_id: 10},
  {content: "or try this on: #bravery", user_id: 1, feedback_id: 10},
  {content: "#stopsucking", user_id: 1, feedback_id: 20},
  {content: "does it?", user_id: 1, feedback_id: 21},
  {content: "does it??", user_id: 1, feedback_id: 21},
  {content: "comment", user_id: 1, feedback_id: 22},
  {content: "with comment", user_id: 1, feedback_id: 23},
  {content: "hey", user_id: 1, feedback_id: 24},
  {content: "doesn't submit though, right?\r\n\r\nwe will see.", user_id: 1, feedback_id: 24},
  {content: "but then what?\r\nare we going to keep running with this until the end of time?\r\n\r\ni don't like it", user_id: 1, feedback_id: 24},
  {content: "am i that brave? #flattered", user_id: 1, feedback_id: 10},
  {content: "this will be ugly #sodamnuglyithurts", user_id: 1, feedback_id: 25},
  {content: "much better", user_id: 1, feedback_id: 26},
  {content: "sup wit it?", user_id: 1, feedback_id: 25},
  {content: "hey", user_id: 2, feedback_id: 20},
  {content: "it's", user_id: 2, feedback_id: 20},
  {content: "me!", user_id: 2, feedback_id: 20},
  {content: "tony!", user_id: 2, feedback_id: 20},
  {content: "work for me", user_id: 1, feedback_id: 26},
  {content: "Thanks you guise..", user_id: 1, feedback_id: 19},
  {content: "huh?\r\n", user_id: 1, feedback_id: 15},
  {content: "yuuuup", user_id: 1, feedback_id: 33},
  {content: "with comment", user_id: 1, feedback_id: 34},
  {content: "hey", user_id: 1, feedback_id: 35},
  {content: "what?", user_id: 1, feedback_id: 36},
  {content: "Me contributing!", user_id: 1, feedback_id: 4},
  {content: "get bizy", user_id: 2, feedback_id: 46},
  {content: "stop slacking", user_id: 2, feedback_id: 46},
  {content: "see above ^^", user_id: 1, feedback_id: 48},
  {content: "cmon bro", user_id: 1, feedback_id: 41},
  {content: "but sreiously, stop it", user_id: 1, feedback_id: 41},
  {content: "thanks for this..", user_id: 2, feedback_id: 41},
  {content: "get it together brother", user_id: 1, feedback_id: 41},
  {content: "s", user_id: 1, feedback_id: 52},
  {content: "Some additional coment", user_id: 1, feedback_id: 52},
  {content: "I disagree -- you're doing a great job!", user_id: 3, feedback_id: 52},
  {content: "hear hear!", user_id: 1, feedback_id: 53},
  {content: "tony comment", user_id: 2, feedback_id: 53},
  {content: "Please everyone try to weigh in!", user_id: 1, feedback_id: 55}
])
Feedback.create!([
  {user_id: 1, author_id: 2, content: "This is the first feedback in the system! Way to go!!", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "Lets see what it looks like with peers", resonance_value: 0},
  {user_id: 2, author_id: 3, content: "LOOK AT ME NOW!", resonance_value: 0},
  {user_id: 2, author_id: 4, content: "Get on to the machine, bro!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "It's coming together man!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Hey I like your style", resonance_value: 0},
  {user_id: 4, author_id: 1, content: "User two, try to do something useful", resonance_value: 0},
  {user_id: 5, author_id: 1, content: "Hey there user 3", resonance_value: 0},
  {user_id: 5, author_id: 1, content: "Try it again then!", resonance_value: 1},
  {user_id: 1, author_id: 2, content: "It works on an enter..?", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Yea man, I don't understand quite yet :(", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Can I comment on a new feedback?", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "How about now?", resonance_value: 0},
  {user_id: 5, author_id: 1, content: "And now?", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "test", resonance_value: 0},
  {user_id: 1, author_id: 1, content: "Good it didn't work", resonance_value: -1},
  {user_id: 4, author_id: 1, content: "We are getting somewhere!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Lets test some comment scoring", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "new comment logic", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "You really sucked it up at the meeting today", resonance_value: 0},
  {user_id: 1, author_id: 1, content: "sup sup!", resonance_value: -1},
  {user_id: 1, author_id: 1, content: "lets leave a feedback, eh?", resonance_value: -1},
  {user_id: 1, author_id: 1, content: "new feedback", resonance_value: -1},
  {user_id: 1, author_id: 1, content: "do i need that role?", resonance_value: -1},
  {user_id: 1, author_id: 1, content: "Some long winded feedback.\r\nWith a space right here.\r\n\r\nAnd 2 spaces here.\r\n\r\n\r\nAnd at 3? That's all i have to say about that", resonance_value: -1},
  {user_id: 1, author_id: 1, content: "trial run, eh?", resonance_value: -1},
  {user_id: 2, author_id: 1, content: "just testing that I can only add unassigned peers", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "testing the peers things again...", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "adding everyone to this one..", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "again?", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "I can't understand why they won't add in. DEBUG!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "what the hell man!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "i think i got it this time", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "testing share updating", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "sup", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "you suck", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Notification testing", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "Another notification test. Should have 2 now", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "a third notification!", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "and here is a fourth!", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "stop sucking", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "notifications are getting a little weird", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "notification much?", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "test", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "I don't appreicate it", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "and here is another for your mind", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "cut it out", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "don't be a pussy\r\nyou've got this\r\nwe've got this\r\nwe are going to make it", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "last test", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "on a double", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "promise", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "and we're in :)", resonance_value: 0},
  {user_id: 1, author_id: 2, content: "New colors are looking sexy mang", resonance_value: 0},
  {user_id: 2, author_id: 6, content: "New feedback for old tony", resonance_value: 0},
  {user_id: 2, author_id: 1, content: "New feedback for tony?", resonance_value: 0},
  {user_id: 3, author_id: 1, content: "another feedback in a row", resonance_value: 0},
  {user_id: 1, author_id: 1, content: "self feedback", resonance_value: nil},
  {user_id: 2, author_id: 1, content: "You're doing a great job with the site", resonance_value: 0}
])
FeedbackLink.create!([
  {feedback_id: nil, user_id: 3, agree: nil},
  {feedback_id: nil, user_id: 4, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 3, agree: nil},
  {feedback_id: nil, user_id: 4, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: 2, user_id: 3, agree: nil},
  {feedback_id: 2, user_id: 4, agree: nil},
  {feedback_id: 2, user_id: 5, agree: nil},
  {feedback_id: 3, user_id: 4, agree: nil},
  {feedback_id: 4, user_id: 1, agree: false},
  {feedback_id: 5, user_id: 3, agree: nil},
  {feedback_id: 5, user_id: 4, agree: nil},
  {feedback_id: 5, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: nil, agree: nil},
  {feedback_id: nil, user_id: nil, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: 9, user_id: 2, agree: true},
  {feedback_id: 9, user_id: 4, agree: nil},
  {feedback_id: 10, user_id: 3, agree: nil},
  {feedback_id: 10, user_id: 5, agree: nil},
  {feedback_id: 11, user_id: 3, agree: nil},
  {feedback_id: 11, user_id: 4, agree: nil},
  {feedback_id: 12, user_id: 3, agree: nil},
  {feedback_id: 13, user_id: 5, agree: nil},
  {feedback_id: 14, user_id: 5, agree: nil},
  {feedback_id: 15, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: 16, user_id: 2, agree: nil},
  {feedback_id: 17, user_id: 3, agree: nil},
  {feedback_id: 17, user_id: 5, agree: nil},
  {feedback_id: 18, user_id: 4, agree: nil},
  {feedback_id: 19, user_id: 3, agree: nil},
  {feedback_id: 20, user_id: 3, agree: nil},
  {feedback_id: 20, user_id: 4, agree: nil},
  {feedback_id: 21, user_id: 2, agree: nil},
  {feedback_id: 22, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: 23, user_id: 2, agree: nil},
  {feedback_id: 23, user_id: 4, agree: nil},
  {feedback_id: 24, user_id: 2, agree: nil},
  {feedback_id: 25, user_id: 3, agree: nil},
  {feedback_id: 25, user_id: 4, agree: nil},
  {feedback_id: 26, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: nil, user_id: 3, agree: nil},
  {feedback_id: nil, user_id: 3, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 3, agree: nil},
  {feedback_id: nil, user_id: 5, agree: nil},
  {feedback_id: nil, user_id: 2, agree: nil},
  {feedback_id: 26, user_id: 2, agree: nil},
  {feedback_id: 26, user_id: 2, agree: nil},
  {feedback_id: 26, user_id: 2, agree: nil},
  {feedback_id: 33, user_id: 3, agree: nil},
  {feedback_id: 33, user_id: 5, agree: nil},
  {feedback_id: 33, user_id: 4, agree: nil},
  {feedback_id: 34, user_id: 3, agree: nil},
  {feedback_id: 34, user_id: 4, agree: nil},
  {feedback_id: 34, user_id: 5, agree: nil},
  {feedback_id: 35, user_id: 3, agree: nil},
  {feedback_id: 35, user_id: 4, agree: nil},
  {feedback_id: 35, user_id: 5, agree: nil},
  {feedback_id: 36, user_id: 3, agree: nil},
  {feedback_id: 37, user_id: 4, agree: nil},
  {feedback_id: 38, user_id: 4, agree: nil},
  {feedback_id: 38, user_id: 6, agree: nil},
  {feedback_id: 41, user_id: 4, agree: nil},
  {feedback_id: 41, user_id: 3, agree: nil},
  {feedback_id: 41, user_id: 7, agree: false},
  {feedback_id: 41, user_id: 6, agree: false},
  {feedback_id: 4, user_id: 5, agree: nil},
  {feedback_id: 4, user_id: 3, agree: nil},
  {feedback_id: 52, user_id: 3, agree: false},
  {feedback_id: 52, user_id: 5, agree: nil},
  {feedback_id: 52, user_id: 6, agree: nil},
  {feedback_id: 52, user_id: 7, agree: nil},
  {feedback_id: 53, user_id: 5, agree: nil},
  {feedback_id: 53, user_id: 4, agree: nil},
  {feedback_id: 54, user_id: 1, agree: false},
  {feedback_id: 55, user_id: 4, agree: nil},
  {feedback_id: 55, user_id: 6, agree: nil},
  {feedback_id: 56, user_id: 2, agree: false},
  {feedback_id: 58, user_id: 3, agree: nil},
  {feedback_id: 58, user_id: 4, agree: nil}
])
ManagerEmployee.create!([
  {employee_id: 4, manager_id: 6},
  {employee_id: 5, manager_id: 6}
])
Notification.create!([
  {user_id: 4, feedback_id: 37, comment_id: nil},
  {user_id: 4, feedback_id: 38, comment_id: nil},
  {user_id: 4, feedback_id: 41, comment_id: nil},
  {user_id: 4, feedback_id: 4, comment_id: nil},
  {user_id: 4, feedback_id: 41, comment_id: 60},
  {user_id: 4, feedback_id: 41, comment_id: 61},
  {user_id: 4, feedback_id: 41, comment_id: 62},
  {user_id: 4, feedback_id: 41, comment_id: 63},
  {user_id: 5, feedback_id: 4, comment_id: nil},
  {user_id: 5, feedback_id: 52, comment_id: nil},
  {user_id: 3, feedback_id: 52, comment_id: nil},
  {user_id: 3, feedback_id: 52, comment_id: nil},
  {user_id: 5, feedback_id: 52, comment_id: 66},
  {user_id: 5, feedback_id: 53, comment_id: nil},
  {user_id: 5, feedback_id: 53, comment_id: 67},
  {user_id: 4, feedback_id: 53, comment_id: nil},
  {user_id: 4, feedback_id: 53, comment_id: 68},
  {user_id: 5, feedback_id: 53, comment_id: 68},
  {user_id: 4, feedback_id: 55, comment_id: nil},
  {user_id: 4, feedback_id: 55, comment_id: 69},
  {user_id: 3, feedback_id: 56, comment_id: nil},
  {user_id: 3, feedback_id: 58, comment_id: nil},
  {user_id: 4, feedback_id: 58, comment_id: nil},
  {user_id: 3, feedback_id: 56, comment_id: nil}
])
Organization.create!([
  {name: "Prophet LLC"}
])
Admin.create!([
  {email: "admin@gmail.com", first_name: "Admin", last_name: "Man", encrypted_password: "$2a$10$H.km77uMUBsWxYo/fvoQa.xEPrns3IXDqUdOmeSD/5zXc/uT1n0y6", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 10, current_sign_in_at: "2016-03-18 21:07:49", last_sign_in_at: "2016-03-18 05:44:18", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@AdminMan", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: "I am the all ruling overlord!", title: nil, type: "Admin", organization_id: 1}
])
Manager.create!([
  {email: "manager@gmail.com", first_name: "Captain", last_name: "Manager", encrypted_password: "$2a$10$ySzEwvXn5yKskBGeSKRhJeoxwHPyyJZ77m7wNwaZhxnTcT1w8e3hS", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 12, current_sign_in_at: "2016-03-19 01:16:13", last_sign_in_at: "2016-03-18 17:32:38", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", user_tag: "@CaptainManager", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, bio: "I'm managing all these homies", title: nil, type: "Manager", organization_id: 1}
])
