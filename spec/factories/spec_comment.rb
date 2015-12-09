FactoryGirl.define do
  factory :spec_comment, class: Comment do
    feedback_id 1
    user_id 1
    content "This is the comment I'm leaving"
  end
end