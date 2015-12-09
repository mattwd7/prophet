FactoryGirl.define do

  factory :spec_feedback, class: Feedback do
    author_id 1
    user_id 2
    content "I'm the feedback content, look at me!"
  end

  factory :spec_full_feedback, class: Feedback do
    author_id 1
    user_id 2
    content "I'm the feedback content, look at me!"
    after(:create) do |f|
      u1 = FactoryGirl.create(:spec_user, email: 'peer1@gmail.com')
      u2 = FactoryGirl.create(:spec_user, email: 'peer2@gmail.com')
      u3 = FactoryGirl.create(:spec_user, email: 'peer3@gmail.com')
      FactoryGirl.create(:spec_feedback_link, user: u1, feedback: f, agree: true)
      FactoryGirl.create(:spec_feedback_link, user: u2, feedback: f, agree: true)
      FactoryGirl.create(:spec_feedback_link, user: u3, feedback: f)
      FactoryGirl.create(:spec_comment, feedback: f, user: u1, content: "I have to say I agree with this feedback. Please do better.")
      FactoryGirl.create(:spec_comment, feedback: f, user: u2, content: "I also agree with this feedback, but noticed you've gotten better.")
    end
  end

end