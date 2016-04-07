require 'rails_helper'

describe User do
  it 'has a valid factory' do
    user = FactoryGirl.build(:spec_user)
    expect(user.save).to eq(true)
  end

  it 'creates a unique, camelcase user_tag on creation' do
    user = FactoryGirl.create(:spec_user, first_name: 'matthew', last_name: 'dick')
    expect(user.user_tag).to eq('@MatthewDick')
    user2 = FactoryGirl.create(:spec_user, email: 'different_email@gmail.com', first_name: 'matthew', last_name: 'dick')
    expect(user2.user_tag).to eq('@MatthewDick-1')
  end

  it 'changes the user_tag when first_name or last_name is changed' do
    user = FactoryGirl.create(:spec_user, first_name: 'matthew', last_name: 'dick')
    expect(user.user_tag).to eq('@MatthewDick')
    user.update_attributes(first_name: 'brian')
    expect(user.user_tag).to eq('@BrianDick')
    user2 = FactoryGirl.create(:spec_user, first_name: 'brian', last_name: 'dick', email: 'bdick@gmail.com')
    expect(user2.user_tag).to eq('@BrianDick-1')
    user2.update_attributes(first_name: 'jason')
    expect(user2.user_tag).to eq('@JasonDick-1')
    user3 = FactoryGirl.create(:spec_user, first_name: 'jason', last_name: 'dick', email: 'jdick@gmail.com')
    expect(user3.user_tag).to eq('@JasonDick-2')
  end

  it 'creates mailer settings on creation' do
    user = FactoryGirl.create(:spec_user)
    expect(user.email_settings.count).to be > 0
  end


end