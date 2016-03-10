require 'rails_helper'

describe 'Notifications', js: true do
  before(:each) do
    @user1 = FactoryGirl.create(:spec_user, email: 'user1@gmail.com')
    @author = FactoryGirl.create(:spec_user, email: 'author@gmail.com')
    @other_user = FactoryGirl.create(:spec_user, email: 'other@gmail.com')
    log_in_with(@user1.email, 'password')
  end

  it 'are issued to ME when a user receives feedback' do
    # expect(page).to_not have_css('.notifications')
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    visit current_path
    expect(@user1.my_notifications.count).to eq(1)
    expect(@user1.team_notifications.count).to eq(0)
    within('.sort .me'){ expect(page).to have_content(1) }
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    visit current_path
    expect(@user1.my_notifications.count).to eq(2)
    expect(@user1.team_notifications.count).to eq(0)
    within('.sort .me'){ expect(page).to have_content(2) }
  end

  it 'are issued to TEAM when a user becomes a peer for a feedback' do
    f = FactoryGirl.create(:spec_feedback, author: @author, user: @other_user)
    FactoryGirl.create(:spec_feedback_link, user: @user1, feedback: f)
    visit current_path
    expect(@user1.my_notifications.count).to eq(0)
    expect(@user1.team_notifications.count).to eq(1)
    expect(@other_user.my_notifications.count).to eq(1)
    expect(Notification.count).to eq(2)
    within('.sort .team'){ expect(page).to have_content(1) }
  end

  it 'are issued when a comment is left on a feedback' do
    f = FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    FactoryGirl.create(:spec_feedback_link, user: @other_user, feedback: f)
    Notification.destroy_all
    expect(@user1.notifications.count).to eq(0)
    FactoryGirl.create(:spec_comment, feedback: f, user: @other_user)
    expect(@user1.my_notifications.count).to eq(1)
    expect(@other_user.team_notifications.count).to eq(0) # the commenter does not receive a notification for his own post
    expect(@author.my_notifications.count).to eq(1)
    expect(Notification.count).to eq(2)
  end

  context 'properly managed' do
    before(:each) do
      @feedback = FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      FactoryGirl.create(:spec_feedback_link, user: @other_user, feedback: @feedback)
      expect(Notification.count).to eq(2)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      expect(Notification.count).to eq(8)
      visit current_path
    end

    it 'count displayed is limited to distinct feedbacks' do
      within('.sort .me'){ expect(page).to have_content(1) }
    end

    it 'hides counter element instead of displaying 0' do
      within('.sort .team'){ expect(page).to_not have_content(0) }
      within('.sort .team'){ expect(page).to_not have_css('.notifications') }
    end

    # it 'are destroyed when a user clicks on a feedback' do
    #   expect(page).to have_css('.feedback.fresh')
    #   first('.feedback').click
    #   expect(page).to_not have_css('.feedback.fresh')
    #   expect(@user.my_feedbacks.count).to eq(0)
    #   expect(Notification.where(user: @user1).count).to eq(0)
    # end

    it 'are destroyed when a user scrolls past a feedback', no_webkit: true do
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      visit current_path
      expect(page).to have_css('.fresh', count: 4)
      within('.sort .me'){ expect(page).to have_content(4) }
      sleep 10
      (1..15).each do |scroll|
        page.execute_script "window.scrollBy(0,100)"
      end
      expect(page).to_not have_css('.fresh')
      within('.sort .me'){ expect(page).to_not have_css('.notifications') }
      expect(@user1.my_notifications.count).to eq(0)
    end

    it 'brings the associated feedback to the top of the users feed'

  end

end