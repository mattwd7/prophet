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
    # page.driver.browser.accept_js_confirms
    expect(page).to have_css('.modal')
    expect(page).to have_content('Are you sure you want to delete your comment?')
    find('.modal .submit-tag').click
    expect(page).to_not have_content(comment.content)
    expect(@feedback.comments.count).to eq(2)
    expect(page).to_not have_css('.delete')
  end

  it 'is displayed with share activity in order of occurrence' do
    new_user = FactoryGirl.create(:spec_user, email: "newuser@gmail.com")
    find('.action.share').click
    find('#additional_peers').set new_user.user_tag
    within('#share-panel'){ find('.action .share').click }
    within('.commenting') do
      expect(page).to have_content("#{@other_user.full_name} added #{new_user.full_name}")
    end
    new_comment = FactoryGirl.create(:spec_comment, feedback: @feedback, user: new_user, content: 'My first comment since being added')
    visit current_path
    within('.commenting') do
      expect(page).to have_content("#{@other_user.full_name} added #{new_user.full_name}")
      expect(page).to have_content(new_comment.content)
    end
  end

  it 'only shows the first so many characters of a very long feedback' do
    long_content = "This is my super suuuuper long feedback. Im pissed off about a lot of things and I need whoever Im sending this to to know all about it. If you think I was just going to let it go, you are so mistaken. I demand a greater level of respect that what you showed me at the meeting today. The whole thing was completely unacceptable. In fact, youll be in touch with my lawyer before long. Thats just the way this is going to go. See you in court asshole!"
    comment = @feedback.comments.first
    comment.update_attributes(content: long_content)
    visit current_path
    within("#comment-#{comment.id}") do
      expect(page).to have_css('a', text: 'See More')
      expect(page).to have_content('This is my super suuuuper long feedback.')
      expect(page).to_not have_content('See you in court asshole!')
    end
    find('a', text: 'See More').click
    expect(page).to have_content('See you in court asshole!')
  end

end