require 'rails_helper'

describe 'Feedback followup' do
  before(:each) do
    @feedback = FactoryGirl.create(:spec_full_feedback)
    @user = @feedback.user
  end

  it 'is issued after 30 days' do
    Periodic.follow_ups
    expect(@feedback.followed_up?).to be_falsey
    @feedback.update_attributes(created_at: 32.days.ago)
    Periodic.follow_ups
    @feedback.reload
    expect(@feedback.followed_up?).to eq(true)
  end

  it 'creates a notification' do
    notification_count = Notification.count
    @feedback.update_attributes(created_at: 32.days.ago)
    Periodic.follow_ups
    expect(Notification.count).to eq(notification_count + 1)
  end

  # it 'sends an email (to peers? to recipient after peers have followed up?)' do
  #   mail_count = ActionMailer::Base.deliveries.count
  #   @recipient = @feedback.user
  #   expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
  # end

  context 'in browser', js: true do
    before(:each) do
      @feedback.update_attributes(created_at: 30.days.ago - 1.minute)
      Periodic.follow_ups
      @peer = @feedback.peers.last
      @author = @feedback.author
    end

    # TODO: this is failing but works on localhost:3000
    it 'hides normal commenting and creates a new css element at the top of the feedback for commenting', no_webkit: true do
      log_in_with(@peer.email, 'password')
      find('.sort .home').click
      within('#feedback-' + @feedback.id.to_s) do
        expect(page).to have_css('.follow-up')
        expect(page).to have_content('30-Day Follow-up')
        within('.follow-up') do
          expect(page).to have_css('textarea')
          find('textarea').set "You've really progressed. Good show!"
          find('.submit-tag').click
        end
        expect(page).to have_content('Thank you for following up!')
      end
    end

    it 'displays follow-up for author' do
      log_in_with(@author.email, 'password')
      within('#feedback-' + @feedback.id.to_s) do
        expect(page).to have_css('.follow-up')
        expect(page).to have_content('30-Day Follow-up')
        within('.follow-up') do
          expect(page).to have_css('textarea')
          find('textarea').set "You've really progressed. Good show!"
          find('.submit-tag').click
        end
        expect(page).to have_content('Thank you for following up!')
      end
    end

  end

end