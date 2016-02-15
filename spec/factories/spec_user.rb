FactoryGirl.define do
  factory :spec_user, class: User do
    first_name 'Matthew'
    last_name 'Dick'
    email 'matt@gmail.com'
    password 'password'
  end

  factory :spec_manager, class: Manager do
    first_name 'Captain'
    last_name 'Manager'
    email 'manager@gmail.com'
    password 'password'
    type 'Manager'
  end
end