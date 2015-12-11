require 'rails_helper'

describe 'User' do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
    log_in_with(@user.email, 'password')
  end

  it 'signs into and out of his account' do
    expect(page).to have_content(@user.email)
    expect(page).to have_content('Sign Out')
    click_link 'Sign Out'
    expect(page).to have_css('#user_email')
  end

  it 'can create feedback for a coworker' do
    expect(@recipient.feedbacks.count).to eq(0)
    # error handling
    find("#feedback_content").set "@TonyDeBINO Feedback content for Tony is HERE."
    click_button "Submit"
    expect(@recipient.feedbacks.count).to eq(0)
    expect(page).to have_content('user tag')

    find("#feedback_content").set "@TonyDecino Feedback content for Tony is HERE."
    click_button "Submit"
    expect(@recipient.feedbacks.count).to eq(1)
    expect(@recipient.feedbacks.first.content).to_not match(/\@\S+/)
  end

  it 'can ask for feedback for himself' do
    expect(@user.feedbacks.count).to eq(0)
    find("#feedback_content").set "@me Did I effectively communicate the company's goals at the meeting today?"
    click_button 'Submit'
    expect(@user.feedbacks.count).to eq(1)
    feedback = @user.feedbacks.first
    within "#feedback-#{feedback.id}" do
      expect(page).to_not have_css('.score')
    end
  end

  it 'can create a feedback with peers' do
    (1..3).each do |num|
      FactoryGirl.create(:spec_user, email: "user#{num}@gmail.com", first_name: "John", last_name: "Doe")
    end
    find("#feedback_content").set "@TonyDecino Feedback content for Tony is HERE."
    find('#peers').set '@JohnDoe @JohnDoe-1 @JohnDoe-2'
    click_button "Submit"
    expect(Feedback.last.peers.count).to eq(3)
  end


end