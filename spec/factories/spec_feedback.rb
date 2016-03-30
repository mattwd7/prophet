FactoryGirl.define do

  factory :spec_feedback, class: Feedback do
    author_id 1
    user_id 2
    content "I'm the feedback content, look at me!"
  end

  factory :spec_full_feedback, class: Feedback do
    content "I'm the feedback content, look at me!"
    after(:build) do |f|
      if f.user_id.nil?
        user = FactoryGirl.create(:spec_user, email: 'user@gmail.com')
        f.user_id ||= user.id
      end
      if f.author_id.nil?
        author = FactoryGirl.create(:spec_user, email: 'author@gmail.com')
        f.author_id ||= author.id
      end
      user_count = User.count
      u1 = FactoryGirl.create(:spec_user, first_name: 'Tony', last_name: 'DeCino', email: "peer#{user_count + 1}@gmail.com")
      u2 = FactoryGirl.create(:spec_user, first_name: 'Jason', last_name: 'Dick', email: "peer#{user_count + 2}@gmail.com")
      u3 = FactoryGirl.create(:spec_user, first_name: 'Brian', last_name: 'Dick',  email: "peer#{user_count + 3}@gmail.com")
      FactoryGirl.create(:spec_feedback_link, user: u1, feedback: f, agree: true)
      FactoryGirl.create(:spec_feedback_link, user: u2, feedback: f, agree: true)
      FactoryGirl.create(:spec_feedback_link, user: u3, feedback: f)
      FactoryGirl.create(:spec_comment, feedback: f, user: u1, content: "I have to say I agree with this feedback. Please do better. #lackluster")
      FactoryGirl.create(:spec_comment, feedback: f, user: u2, content: "I also agree with this feedback, but noticed you've gotten better. #stopsucking")
    end
  end

end