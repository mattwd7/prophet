FactoryGirl.define do
  factory :spec_user, class: User do
    first_name 'Matthew'
    last_name 'Dick'
    email 'matt@gmail.com'
  end
end