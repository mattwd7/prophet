require 'rails_helper'

describe 'User', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
  end

  it 'in env without feedback sees that there is no content' do
    log_in_with(@user.email, 'password')
    expect(page).to have_content('No feedback yet. Create feedback to start things off!')
  end

  it 'without personal feedback defaults to ALL' do
    @team1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user completely uninvolved
    log_in_with(@user.email, 'password')

    expect(page).to have_css('.team.selected')
    expect(page).to have_content(@team1.content)
  end

  context 'in established environment' do
    before(:each) do
      @mine1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user) # @user is feedback recipient
      @mine2 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user) # @user is feedback recipient
      @mine3 = FactoryGirl.create(:spec_full_feedback, author: @user, user: @author) # @user is author
      @team1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user completely uninvolved

      @peer1 = FactoryGirl.create(:spec_full_feedback, author: @author, user: @recipient) # @user is a peer
      FactoryGirl.create(:spec_feedback_link, user: @user, feedback: @peer1)
      @peer1.comments.each do |c|
        FactoryGirl.create(:spec_comment_link, user: @user, comment: c)
      end
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
      sleep 1
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
        expect(page).to have_content('2')
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

      within("#feedback-#{@mine3.id}") do
        within(first('.comment')) do
          within('.votes') do
            within('.dismiss'){ expect(page).to have_content(@mine3.peers.count + 1) }
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

      within("#feedback-#{@team1.id}") do
        within(first('.comment')) do
          within('.votes') do
            within('.dismiss'){ expect(page).to have_content(@team1.peers.count + 1) }
            expect(page).to have_content(1) # peer-generated comment gets +1
            expect(page).to_not have_css('active') # I cannot vote on the comment in a feedback I am not a peer of
          end
        end
      end
    end

    it 'sees self-involved feedback on ME feedback and all other feedback on TEAM feed' do
      expect(page).to have_css("#feedback-#{@mine1.id}")
      expect(page).to have_css("#feedback-#{@mine2.id}")
      expect(page).to have_css("#feedback-#{@mine3.id}")
      expect(page).to_not have_css("#feedback-#{@team1.id}")
      find('.sort .team').click
      expect(page).to_not have_css("#feedback-#{@mine1.id}")
      expect(page).to_not have_css("#feedback-#{@mine2.id}")
      expect(page).to_not have_css("#feedback-#{@mine3.id}")
      expect(page).to have_css("#feedback-#{@team1.id}")

    end
  end


end