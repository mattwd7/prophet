require 'rails_helper'

describe 'User', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
  end

  it 'in env without feedback sees that there is no content' do
    log_in_with(@user.email, 'password')
    expect(page).to have_content('No feedback results found.')
  end

  it 'without personal feedback defaults to ALL' do
    @peer1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user is a peer
    FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @peer1)
    @peer1.comments.each do |c|
      FactoryGirl.create(:spec_comment_link, user: @user, comment: c)
    end
    log_in_with(@user.email, 'password')

    expect(page).to have_css('.team.selected')
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
      @peer1.comments.each do |c|
        FactoryGirl.create(:spec_comment_link, user: @user, comment: c)
      end
      log_in_with(@user.email, 'password')
    end

    it 'signs into and out of his account' do
      find('#session').hover
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

    it 'can ask for feedback for himself', no_webkit: true do
      init_count = @user.feedbacks.count
      last_id = Feedback.last.id
      find("#feedback_content").set "#{@user.user_tag} Did I effectively communicate the company's goals at the meeting today?"
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
      visit root_path
      expect(comment_count).to eq(6)
      within("#feedback-#{@i_am_author.id}") do
        expect(page).to have_css('.comment', count: 2)
        expect(page).to have_content("View 4 more comments")
        find('#comment_content').click
        expect(page).to have_content("Submit")
        find('#comment_content').set "This is my new comment\n"
        find('.submit-tag').click
        expect(page).to have_css('.comment', count: 3)
        click_link "View 4 more comments"
        expect(page).to have_css('.comment', count: 7)
        expect(page).to_not have_content("View 4 more comments")
      end
    end

    it 'can vote on a feedback he is a peer of' do
      FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @team1)
      @team1.reload
      visit current_path
      expect(@team1.peers).to include(@user)
      agree_count = @team1.peers_in_agreement.count
      visit current_path
      find('.team').click
      expect(page).to have_content(@team1.content)
      within("#feedback-#{@team1.id}") do
        expect(page).to have_css('.active')
        first('.agree').click
        sleep 1
        @team1.reload
        expect(@team1.peers_in_agreement.count).to eq(agree_count + 1)
        first('.dismiss').click
        sleep 1
        @team1.reload
        expect(@team1.peers_in_agreement.count).to eq(agree_count)
        expect(page).to have_content(agree_count + 1)
      end
    end

    it 'can vote on a comment he is a peer of' do
      within("#feedback-#{@mine1.id}") do
        within(first('.comment')) do
          within('.votes') do
            expect('.agree').to_not have_content(1) # i'm not a peer, so my comment on my feedback does not get 1 agree
            expect(page).to_not have_css('active') # i cannot vote on my own comment
          end
        end
      end

      within("#feedback-#{@i_am_author.id}") do
        within(first('.comment')) do
          within('.votes') do
            within('.dismiss'){ expect(page).to have_content(@i_am_author.peers.count + 1) }
            expect(page).to have_content(1) # my comment gets a +1 and I cannot change it
            expect(page).to_not have_css('active')
          end
        end
      end

      find(".team").click
      within("#feedback-#{@peer1.id}") do
        within(first('.comment')) do
          expect(page).to have_css('.active') # as a peer, I can vote to agree on this comment
          within('.votes') do
            within('.dismiss'){ expect(page).to have_content(@peer1.peers.count + 1) }
            expect(page).to have_content(1) # my comment gets a +1 and I cannot change it
            agree_count = @peer1.comments.first.peers_in_agreement.count
            find('.agree').click
            sleep 1
            expect(@peer1.comments.first.peers_in_agreement.count).to eq(agree_count + 1)
          end
        end
      end
    end

    it 'sees received feedback on ME feedback and all feedback he is a peer to on TEAM feed' do
      expect(page).to have_css("#feedback-#{@mine1.id}")
      expect(page).to have_css("#feedback-#{@mine2.id}")
      expect(page).to have_css("#feedback-#{@i_am_author.id}")
      expect(page).to_not have_css("#feedback-#{@team1.id}")
      expect(page).to_not have_css("#feedback-#{@peer1.id}")
      find('.sort .team').click
      expect(page).to_not have_css("#feedback-#{@mine1.id}")
      expect(page).to_not have_css("#feedback-#{@mine2.id}")
      expect(page).to_not have_css("#feedback-#{@i_am_author.id}")
      expect(page).to_not have_css("#feedback-#{@team1.id}")
      expect(page).to have_css("#feedback-#{@peer1.id}")
    end

    it 'has additional feedback actions AGREE and DISMISS as a peer' do
      expect(page).to_not have_css('.action', text: 'Agree')
      expect(page).to_not have_css('.action', text: 'Dismiss')
      find('.sort .team').click
      within("#feedback-#{@peer1.id}") do
        expect(page).to have_css('.action', text: 'Agree')
      end
      agree_count = @peer1.peers_in_agreement.count
      within("#feedback-#{@peer1.id}") do
        expect(page).to_not have_css('.vote.agree.selected')
        expect(page).to have_css('.vote.dismiss.selected')
        find('.action', text: 'Agree').click
        expect(page).to have_css('.vote.agree.selected')
        expect(page).to_not have_css('.vote.dismiss.selected')
        sleep 2 # TODO: figure out how to wait for ajax
        @peer1.reload
        expect(@peer1.peers_in_agreement.count).to eq(agree_count + 1)
        find('.action', text: 'Agree').click
        expect(page).to_not have_css('.vote.agree.selected')
        expect(page).to have_css('.vote.dismiss.selected')
        @peer1.reload
        sleep 2 # TODO: figure out how to wait for ajax
        expect(@peer1.peers_in_agreement.count).to eq(agree_count)
      end
    end
  end


end