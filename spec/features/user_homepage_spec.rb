require 'rails_helper'

describe 'User', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
    @mine1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user)
    @mine2 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user)
    @mine3 = FactoryGirl.create(:spec_full_feedback, author: @user, user: @author)
    @all1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient)
    log_in_with(@user.email, 'password')
  end

  it 'signs into and out of his account' do
    expect(page).to have_content(@user.email)
    expect(page).to have_content('Sign Out')
    click_link 'Sign Out'
    expect(page).to have_css('#user_email')
  end

  it 'can create feedback for a coworker' do
    init_count = @recipient.feedbacks.count
    # error handling
    find("#feedback_content").set "@TonyDeBINO Feedback content for Tony is HERE."
    within('.feedback-form'){ click_button "Submit" }
    expect(@recipient.feedbacks.count).to eq(init_count)
    expect(page).to have_content('user tag')

    find("#feedback_content").set "@TonyDecino Feedback content for Tony is HERE."
    within('.feedback-form'){ click_button "Submit" }
    sleep 1
    expect(@recipient.feedbacks.count).to eq(init_count + 1)
    expect(@recipient.feedbacks.last.content).to_not match(/\@\S+/)
  end

  it 'can ask for feedback for himself' do
    init_count = @user.feedbacks.count
    find("#feedback_content").set "@me Did I effectively communicate the company's goals at the meeting today?"
    within('.feedback-form'){ click_button 'Submit' }
    sleep 1
    expect(@user.feedbacks.count).to eq(init_count + 1)
    feedback = @user.feedbacks.last
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
    within('.feedback-form'){ click_button "Submit" }
    expect(Feedback.last.peers.count).to eq(3)
  end

  it 'can comment on feedback' do
    comment_count = @mine3.comments.count
    within("#feedback-#{@mine3.id}") do
      find('#comment_content').set 'This is my new comment'
      click_button 'Submit'
      sleep 1
      expect(@mine3.comments.count).to eq(comment_count + 1)
      expect(page).to have_content(@mine3.comments.last.content)
    end
  end

  it 'can vote on a feedback or a comment he is a peer of' do
    FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @all1)
    expect(@all1.peers).to include(@user)
    agree_count = @all1.peers_in_agreement.count
    visit current_path
    find('.all').click
    expect(page).to have_content(@all1.content)
    within("#feedback-#{@all1.id}") do
      expect(page).to have_css('.active')
      first('.agree').click
      sleep 1
      @all1.reload
      expect(@all1.peers_in_agreement.count).to eq(agree_count + 1)
      first('.dismiss').click
      sleep 1
      @all1.reload
      expect(@all1.peers_in_agreement.count).to eq(agree_count)
      expect(page).to have_content('2')
    end
  end

  it 'sees self-involved feedback on ME feedback and all other feedback on ALL feed' do
    expect(page).to have_css("#feedback-#{@mine1.id}")
    expect(page).to have_css("#feedback-#{@mine2.id}")
    expect(page).to have_css("#feedback-#{@mine3.id}")
    expect(page).to_not have_css("#feedback-#{@all1.id}")
    find('.sort .all').click
    expect(page).to_not have_css("#feedback-#{@mine1.id}")
    expect(page).to_not have_css("#feedback-#{@mine2.id}")
    expect(page).to_not have_css("#feedback-#{@mine3.id}")
    expect(page).to have_css("#feedback-#{@all1.id}")

  end


end