require 'rails_helper'

describe 'User', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
  end

  it 'can request an account on the main page, receiving an email' do
    mail_count = ActionMailer::Base.deliveries.count
    visit root_path
    expect(page).to have_content("Sign Up")
    within('#registration') do
      find('#first_name').set "Matthew"
      find('#last_name').set "Dick"
      find("#email").set "matt@gmail.com"
      find("#email_confirmation").set "matt@gmail.com"
      find("#company").set "PROPHET"
      find('.submit-tag').click
    end
    expect(page).to have_content('Thank you for your interest! We will contact you as soon as possible.')
    expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
  end

  it 'in env without feedback sees that there is no content' do
    log_in_with(@user.email, 'password')
    expect(page).to have_content('No feedback results found.')
  end

  it 'without personal feedback defaults to ALL' do
    @peer1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user is a peer
    FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @peer1)
    # @peer1.comments.each do |c|
    #   FactoryGirl.create(:spec_comment_link, user: @user, comment: c)
    # end
    log_in_with(@user.email, 'password')

    expect(page).to have_css('.home.selected')
    expect(page).to have_content(@peer1.content)
  end

  context 'in established environment' do
    before(:each) do
      @mine1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user) # @user is feedback recipient
      @mine2 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user) # @user is feedback recipient
      @i_am_author = FactoryGirl.create(:spec_full_feedback, author: @user, user: @author) # @user is author
      @team1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user completely uninvolved
      @peer1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user is a peer
      FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @peer1)
      # @peer1.comments.each do |c|
      #   FactoryGirl.create(:spec_comment_link, user: @user, comment: c)
      # end
      log_in_with(@user.email, 'password')
    end

    it 'signs into and out of his account' do
      find('.session .avatar').click
      expect(page).to have_content('Edit Profile')
      expect(page).to have_content('Logout')
      click_link 'Logout'
      expect(page).to have_css('#user_email')
    end

    it 'can create feedback for a coworker' do
      init_count = @recipient.feedbacks.count

      find("#feedback_content").set "@TonyDecino Feedback content for Tony is HERE."
      within('.feedback-form'){ find('.submit-tag').click }
      sleep 1
      expect(@recipient.feedbacks.count).to eq(init_count + 1)
      expect(@recipient.feedbacks.last.content).to_not match(/@\S+/)
    end

    it 'cannot ask for self-feedback without peers', no_webkit: true do
      # init_count = @user.feedbacks.count
      # last_id = Feedback.last.id
      # find("#feedback_content").set "#{@user.user_tag} Did I effectively communicate the company's goals at the meeting today?"
      # within('.feedback-form'){ find('.submit-tag').click }
      # expect(page).to have_css("#feedback-#{last_id + 1}")
      # expect(@user.feedbacks.count).to eq(init_count + 1)
      # feedback = @user.feedbacks.last
      # within "#feedback-#{feedback.id}" do
      #   expect(page).to_not have_css('.score')
      # end
    end

    it 'can ask for self-feedback', no_webkit: true do
      init_count = @user.feedbacks.count
      last_id = Feedback.last.id
      find("#feedback_content").set "#{@user.user_tag} Did I effectively communicate the company's goals at the meeting today?"
      find('#peers').set @recipient.user_tag
      within('.feedback-form'){ find('.submit-tag').click }
      expect(page).to have_css("#feedback-#{last_id + 1}")
      expect(@user.feedbacks.count).to eq(init_count + 1)
      feedback = @user.feedbacks.last
      within "#feedback-#{feedback.id}" do
        expect(page).to_not have_css('.score')
      end
    end

    it 'can comment on feedback' do
      comment_count = @i_am_author.comments.count
      within("#feedback-#{@i_am_author.id}") do
        expect(page).to_not have_content("Submit")
        find('#comment_content').click
        expect(page).to have_content("Submit")
        find('#comment_content').set "This is my new comment\n"
        find('.submit-tag').click
        expect(page).to have_css('.comment', count: comment_count + 1)
        expect(@i_am_author.comments.count).to eq(comment_count + 1)
        expect(page).to have_content(@i_am_author.comments.last.content)
      end
    end

    it 'sees only latest 2 comments until clicking to see all', no_webkit: true do
      4.times{ FactoryGirl.create(:spec_comment, user: @i_am_author.user, feedback: @i_am_author) }
      @i_am_author.reload
      comment_count = @i_am_author.comments.count
      Notification.destroy_all
      visit root_path
      expect(comment_count).to eq(6)
      within("#feedback-#{@i_am_author.id}") do
        expect(page).to have_css('.comment', count: 2)
        expect(page).to have_css("#comment-#{@i_am_author.comments.last.id}")
        expect(page).to_not have_css("#comment-#{@i_am_author.comments.first.id}")
        expect(page).to have_content("View 4 more comments")
        find('#comment_content').click
        expect(page).to have_content("Submit")
        find('#comment_content').set "This is my new comment\n"
        find('.submit-tag').click
        expect(page).to have_css('.comment', count: 3)
        click_link "View 4 more comments"
        expect(page).to have_css('.comment', count: 7)
        expect(page).to_not have_content("View 4 more comments")
        expect(page).to have_css("#comment-#{@i_am_author.comments.last.id}")
        expect(page).to have_css("#comment-#{@i_am_author.comments.first.id}")
      end
    end

    it 'can vote on a feedback he is a peer of', no_webkit: true do
      FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @team1)
      @team1.reload
      visit current_path
      expect(@team1.peers).to include(@user)
      agree_count = @team1.peers_in_agreement.count
      visit current_path
      find('.sort .home').click
      expect(page).to have_content(@team1.content)
      within("#feedback-#{@team1.id}") do
        find('.action.agree').click
        sleep 1
        @team1.reload
        expect(@team1.peers_in_agreement.count).to eq(agree_count + 1)
        first('.action.agree').click
        sleep 1
        @team1.reload
        expect(@team1.peers_in_agreement.count).to eq(agree_count)
        expect(page).to have_content(agree_count)
      end
    end

    it 'sees all (me and team) feedback on HOME and feedback received on ME feed' do
      expect(page).to have_css("#feedback-#{@mine1.id}")
      expect(page).to have_css("#feedback-#{@mine2.id}")
      expect(page).to have_css("#feedback-#{@i_am_author.id}")
      expect(page).to_not have_css("#feedback-#{@team1.id}")
      expect(page).to have_css("#feedback-#{@peer1.id}")
      find('.sort .me').click
      expect(page).to have_css("#feedback-#{@mine1.id}")
      expect(page).to have_css("#feedback-#{@mine2.id}")
      expect(page).to have_css("#feedback-#{@i_am_author.id}")
      expect(page).to_not have_css("#feedback-#{@team1.id}")
      expect(page).to_not have_css("#feedback-#{@peer1.id}")
    end

  end


end