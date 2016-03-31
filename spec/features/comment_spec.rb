require 'rails_helper'

describe 'Comment', js: true do
  before(:each) do
    @feedback = FactoryGirl.create(:spec_full_feedback)
    @user = @feedback.user
    @other_user = @feedback.peers.last
    log_in_with(@other_user.email, 'password')
  end

  it 'allows user to edit or delete new comment within 5 minute window of creation or update' do
    within('#new_comment') do
      find('#comment_content').set "This is my new comment"
      find('.submit-tag').click
    end
    sleep 1
    expect(@feedback.comments.count).to eq(3)
    comment = @feedback.comments.last
    within('.commenting') do
      expect(page).to have_css('.comment', count: 3)
      expect(page).to have_css('.edit', count: 1)
      expect(page).to have_css('.delete', count: 1)
    end
    within(all('.comment').last) do
      expect(page).to_not have_css('input')
      find('.edit').click
      expect(page).to have_css('input')
      find('input').set "I'm updating my comment content"
      find('button', text: 'OK').click
    end

    comment.update_attributes(updated_at: 5.minutes.ago)
    comment.reload
    visit current_path
    within('.commenting') do
      expect(page).to_not have_css('.edit')
      expect(page).to_not have_css('.delete')
    end
    comment.update_attributes(updated_at: Time.now)
    visit current_path
    within('.commenting') do
      expect(page).to have_css('.edit')
      expect(page).to have_css('.delete')
      find('.delete a').click
    end
    page.driver.browser.accept_js_confirms
    expect(page).to_not have_content(comment.content)
    expect(@feedback.comments.count).to eq(2)
  end

end