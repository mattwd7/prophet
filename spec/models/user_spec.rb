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

end