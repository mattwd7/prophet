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
    expect(@user1.home_notifications.count).to eq(0)
    within('.sort .me'){ expect(page).to have_content(1) }
    FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    visit current_path
    expect(@user1.my_notifications.count).to eq(2)
    expect(@user1.home_notifications.count).to eq(0)
    within('.sort .me'){ expect(page).to have_content(2) }
  end

  it 'are issued to ME when one of my feedbacks increases in resonance' do
    feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user1)
    init_notifications = Notification.count
    feedback.feedback_links.first.update_attributes(agree: false)
    expect(feedback.resonance_value).to eq(1)
    feedback.feedback_links.all.each{|fl| fl.update_attributes(agree: true)}
    @user1.reload
    expect(Notification.count).to eq(init_notifications + 1)
  end

  it 'are issued to TEAM when a user becomes a peer for a feedback' do
    f = FactoryGirl.create(:spec_feedback, author: @author, user: @other_user)
    FactoryGirl.create(:spec_feedback_link, user: @user1, feedback: f)
    visit current_path
    expect(@user1.my_notifications.count).to eq(0)
    expect(@user1.home_notifications.count).to eq(1)
    expect(@other_user.my_notifications.count).to eq(1)
    expect(Notification.count).to eq(2)
    within('.sort .home'){ expect(page).to have_content(1) }
  end

  it 'are issued when a comment is left on a feedback' do
    f = FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
    FactoryGirl.create(:spec_feedback_link, user: @other_user, feedback: f)
    Notification.destroy_all
    expect(@user1.notifications.count).to eq(0)
    FactoryGirl.create(:spec_comment, feedback: f, user: @other_user)
    expect(@user1.my_notifications.count).to eq(1)
    expect(@other_user.home_notifications.count).to eq(0) # the commenter does not receive a notification for his own post
    expect(@author.my_notifications.count).to eq(1)
    expect(Notification.count).to eq(3)
  end

  context 'properly managed' do
    before(:each) do
      @feedback = FactoryGirl.create(:spec_feedback, author: @author, user: @user1, content: 'first feedback')
      FactoryGirl.create(:spec_feedback_link, user: @other_user, feedback: @feedback)
      expect(Notification.count).to eq(2)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      expect(Notification.count).to eq(11)
      visit current_path
    end

    it 'count displayed is limited to distinct feedbacks' do
      within('.sort .me'){ expect(page).to have_content(1) }
    end

    it 'hides counter element instead of displaying 0' do
      within('.sort .home'){ expect(page).to_not have_content(0) }
      within('.sort .home'){ expect(page).to_not have_css('.notifications') }
    end

    # it 'are destroyed when a user clicks on a feedback' do
    #   expect(page).to have_css('.feedback.fresh')
    #   first('.feedback').click
    #   expect(page).to_not have_css('.feedback.fresh')
    #   expect(@user1.my_notifications.count).to eq(0)
    #   expect(Notification.where(user: @user1).count).to eq(0)
    # end

    it 'are destroyed when a user scrolls past a feedback', no_webkit: true do
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1)
      visit current_path
      expect(page).to have_css('.feedback.fresh', count: 4)
      within('.sort .me'){ expect(page).to have_content(4) }
      find('.sort .me').click
      scroll_to_bottom('slowly')
      expect(page).to_not have_css('.fresh')
      within('.sort .me'){ expect(page).to_not have_css('.notifications') }
      expect(@user1.my_notifications.count).to eq(0)
    end

    it 'brings the freshest feedbacks to the top of the users feed', no_webkit: true do
      scroll_to_bottom('slowly')
      expect(@user1.my_notifications.count).to eq(0)
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1, content: 'second most fresh')
      sleep 1
      FactoryGirl.create(:spec_feedback, author: @author, user: @user1, content: 'Most fresh')
      visit current_path
      within(all('.feedback')[0]){ expect(page).to have_content('Most fresh') }
      within(all('.feedback')[1]){ expect(page).to have_content('second most fresh') }
      within(all('.feedback')[2]){ expect(page).to have_content('first feedback') }
      scroll_to_bottom('slowly')
      expect(@user1.my_notifications.count).to eq(0)
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      expect(@user1.my_notifications.count).to eq(1)
      sleep 1
      visit current_path
      within(all('.feedback')[0]){ expect(page).to have_content(@feedback.content) }
    end

    it 'identifies fresh comments', no_webkit: true do
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      visit current_path
      expect(page).to have_css('.comment.fresh')
      scroll_to_bottom
      within(all('.feedback')[0]){ expect(page).to_not have_css('.fresh') }
    end

    it 'forces fresh comments to display beyond the first 2', no_webkit: true do
      init_count = Notification.count
      scroll_to_bottom('slowly')
      expect(Notification.count).to eq(init_count - 4)
      5.times do
        FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      end
      visit current_path
      within(first('.feedback')) do
        expect(page).to have_css('.comment.fresh', count: 5)
        expect(page).to have_content('View 3 more comments')
      end
    end

    it 'identifies fresh comments after js filter' do
      FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
      visit current_path
      expect(page).to have_css('.comment.fresh')
      find('.sort .me').click
      sleep 1
      find('.sort .home').click
      sleep 1
      expect(page).to have_css('.comment.fresh')
      sleep 1
      scroll_to_bottom
      within(all('.feedback')[0]){ expect(page).to_not have_css('.fresh') }
    end

  end

end