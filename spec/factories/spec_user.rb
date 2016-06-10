FactoryGirl.define do
  factory :spec_user, class: User do
    first_name 'Matthew'
    last_name 'Dick'
    email 'matt@gmail.com'
    password 'password'
    after(:build) do |user|
      user.organization ||= FactoryGirl.create(:spec_organization)
    end
  end

  factory :spec_manager, class: Manager do
    first_name 'Captain'
    last_name 'Manager'
    email 'manager@gmail.com'
    password 'password'
    type 'Manager'
    after(:build) do |user|
      user.organization ||= FactoryGirl.create(:spec_organization)
    end
  end

  factory :spec_admin, class: Admin do
    first_name 'Master'
    last_name 'Admin'
    email 'admin@gmail.com'
    password 'password'
    type 'Admin'
    after(:build) do |user|
      user.organization ||= FactoryGirl.create(:spec_organization)
    end
  end
end