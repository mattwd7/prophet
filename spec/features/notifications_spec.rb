require 'rails_helper'

describe 'Notification', js: true do
  before(:each) do
    @user1 = FactoryGirl.create(:spec_user, email: 'user1@gmail.com')
    @author = FactoryGirl.create(:spec_user, email: 'author@gmail.com')
    @other_user = FactoryGirl.create(:spec_user, email: 'other@gmail.com')
    log_in_with(@user1.email, 'password')
  end

  it 'is issued to ME when a user receives feedback' do
    # expect(page).to_not have_css('.notifications')
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    visit current_path
    expect(@user1.my_notifications).to eq(1)
    expect(@user1.team_notifications).to eq(0)
    within('.sort .me'){ expect(page).to have_content(1) }
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    visit current_path
    expect(@user1.my_notifications).to eq(2)
    expect(@user1.team_notifications).to eq(0)
    within('.sort .me'){ expect(page).to have_content(2) }
  end

  it 'is issued to TEAM when a user becomes a peer for a feedback' do
    f = FactoryGirl.create(:spec_feedback, author: @author, user: @other_user)
    FactoryGirl.create(:spec_feedback_link, user: @user1, feedback: f)
    visit current_path
    expect(@user1.my_notifications).to eq(0)
    expect(@user1.team_notifications).to eq(1)
    within('.sort .team'){ expect(page).to have_content(1) }
  end

  it 'is issued when a comment is left on a feedback' do
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    Notification.first.destroy

  end

  it 'count displayed is limited to distinct feedbacks' do

  end

  it 'is destroyed when a user scrolls past a feedback'

  it 'is destroyed when a user clicks on a feedback'

  it 'brings the associated feedback to the top of the users feed'

end