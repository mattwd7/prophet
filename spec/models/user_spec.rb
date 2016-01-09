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

  it 'has tags collected and counted from his received feedback' do
    recipient = FactoryGirl.create(:spec_user, email: 'matt@gmail.com')
    author = FactoryGirl.create(:spec_user, email: 'author@gmail.com')
    feedback = FactoryGirl.create(:spec_full_feedback, user: recipient, author: author)
    feedback2 = FactoryGirl.create(:spec_full_feedback, user: recipient, author: author)
    peer1 = feedback.peers.first
    peer2 = feedback2.peers.first
    FactoryGirl.create(:spec_comment, user: peer1, feedback: feedback, content: "#leadership")
    FactoryGirl.create(:spec_comment, user: peer1, feedback: feedback, content: "#bravery")
    FactoryGirl.create(:spec_comment, user: peer2, feedback: feedback2, content: "#bravery")
    FactoryGirl.create(:spec_comment, user: peer2, feedback: feedback2, content: "#honor")
    tags = recipient.my_tags
    puts tags
    expect(tags.count).to eq(5)
    expect(tags['#bravery']).to eq(2)
    expect(tags['#leadership']).to eq(1)
    expect(tags['#honor']).to eq(1)
  end
end