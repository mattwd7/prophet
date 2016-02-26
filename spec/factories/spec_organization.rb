FactoryGirl.define do
  factory :spec_organization, class: Organization do
    name 'Smart Org LLC'
  end

  factory :spec_organization_full, class: Organization do
    name 'Smart Org LLC'
    after(:create) do |org|
      FactoryGirl.create(:spec_admin, organization: org)
      (1..10).each{|num| FactoryGirl.create(:spec_user, email: "user#{num}@gmail.com", first_name: "user", last_name: num, organization: org)}
    end
  end
end