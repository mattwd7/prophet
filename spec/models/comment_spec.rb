require 'rails_helper'

describe Comment do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @feedback = FactoryGirl.create(:spec_feedback)
  end

  it 'has a valid factory' do
    @comment = FactoryGirl.build(:spec_comment)
    expect(@comment.save).to eq(true)
  end

  it 'must belong to a user and a feedback' do
    @comment = FactoryGirl.build(:spec_comment, content: "")
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, user: nil)
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, feedback: nil)
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, content: "My Comment")
    result = @comment.save
    puts @comment.errors.full_messages
    expect(result).to eq(true)
  end

  it 'creates comment links for feedback peers' do
    feedback = FactoryGirl.create(:spec_full_feedback)
    comment = FactoryGirl.create(:spec_comment, feedback: feedback, user: feedback.peers.first)
    expect(comment.peers.count).to eq(feedback.peers.count - 1)
  end

end