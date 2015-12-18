require 'rails_helper'

describe Feedback do
  before(:each) do
    @author = FactoryGirl.create(:spec_user, email: 'author1@gmail.com')
    @recipient = FactoryGirl.create(:spec_user, email: 'recipient1@gmail.com')
  end

  it 'has a valid factory' do
    @feedback = FactoryGirl.build(:spec_feedback, user: @recipient, author: @author)
    @feedback.save
    puts @feedback.errors.full_messages
    expect(@feedback.save).to eq(true)
  end

  it 'must have an author and a recipient' do
    @feedback = FactoryGirl.build(:spec_feedback, user_id: nil, author_id: nil)
    expect(@feedback.save).to eq(false)
    @feedback.author_id = 1
    expect(@feedback.save).to eq(false)
    @feedback.user_id = 2
    expect(@feedback.save).to eq(true)
  end

  it 'has one author and one recipient' do
    @feedback = FactoryGirl.create(:spec_feedback, user: @recipient, author: @author)
    expect(@feedback.author).to eq(@author)
    expect(@feedback.user).to eq(@recipient)
    expect(@author.feedbacks.count).to eq(0)
    expect(@author.authored_feedbacks.count).to eq(1)
    expect(@recipient.feedbacks.count).to eq(1)
  end

  it 'must have content' do
    @feedback = FactoryGirl.build(:spec_feedback, user: @recipient, author: @author, content: "")
    expect(@feedback.save).to eq(false)
  end

  it 'creates unique tags if the content has hashtags' do
    content = "Really great job wrapping up that project my man! #leadership #teamplayer #leadership"
    @feedback = FactoryGirl.create(:spec_feedback, user: @recipient, author: @author, content: content)
    expect(@feedback.tags.count).to eq(2)
  end

  context 'with peers' do
    before(:each) do
      @feedback = FactoryGirl.create(:spec_full_feedback)
    end

    it 'has a count of peers' do
      expect(@feedback.peers.count).to be > 0
    end

    it 'has a count of peers in agreement' do
      expect(@feedback.peers_in_agreement.count).to be > 0
    end

    it 'has comments' do
      expect(@feedback.comments.count).to be > 0
    end


  end

end