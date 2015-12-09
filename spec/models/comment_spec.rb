require 'rails_helper'

describe Comment do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
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
    @comment = FactoryGirl.create(:spec_comment, content: "My Comment", user_id: 1)
    expect(@comment.save).to eq(true)
  end

end