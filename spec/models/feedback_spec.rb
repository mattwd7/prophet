require 'rails_helper'

describe Feedback do
  before(:each) do
    @author = FactoryGirl.create(:spec_user, email: 'author1@gmail.com')
    @recipient = FactoryGirl.create(:spec_user, email: 'recipient1@gmail.com')
  end

  it 'has a valid factory' do
    @feedback = FactoryGirl.build(:spec_feedback, user: @recipient, author: @author)
    expect(@feedback.save).to eq(true)
  end

  it 'must have an author and a recipient' do
    @feedback = FactoryGirl.build(:spec_feedback, user_id: nil, author_id: nil)
    expect(@feedback.save).to eq(false)
    @feedback.author_id = 1
    expect(@feedback.save).to eq(false)
    @feedback.user_id = 2
    expect(@feedback.save).to eq(true)
  end

  it 'has one author and one recipient' do
    @feedback = FactoryGirl.create(:spec_feedback, user: @recipient, author: @author)
    expect(@feedback.author).to eq(@author)
    expect(@feedback.user).to eq(@recipient)
    expect(@author.feedbacks.count).to eq(0)
    expect(@author.authored_feedbacks.count).to eq(1)
    expect(@recipient.feedbacks.count).to eq(1)
  end

  it 'must have content' do
    @feedback = FactoryGirl.build(:spec_feedback, user: @recipient, author: @author, content: "")
    expect(@feedback.save).to eq(false)
  end

  it 'determines the user from the content' do
    @feedback = FactoryGirl.build(:spec_feedback, user: nil, author: @author, content: "#{@recipient.user_tag} I need you to receive this content")
    expect(@feedback.save).to eq(true)
    expect(@feedback).to eq(@recipient.feedbacks.first)
    expect(@feedback.content).to eq('I need you to receive this content')
  end

  it 'sends an email to the recipient on creation' do
    mail_count = ActionMailer::Base.deliveries.count
    @recipient.mailer_settings.each{|ms| ms.update_attributes(active?: false)}
    FactoryGirl.create(:spec_feedback, user: @recipient, author: @author)
    expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
    @recipient.mailer_settings.each{|ms| ms.update_attributes(active?: true)}
    FactoryGirl.create(:spec_feedback, user: @recipient, author: @author)
    expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
  end

  context 'with peers' do
    before(:each) do
      @feedback = FactoryGirl.create(:spec_full_feedback)
    end

    it 'has a count of peers' do
      expect(@feedback.peers.count).to be > 0
    end

    it 'has a count of peers in agreement' do
      expect(@feedback.peers_in_agreement.count).to be > 0
    end

    it 'has comments' do
      expect(@feedback.comments.count).to be > 0
    end

    it 'has a resonance value between 0 and 2 that is updated when feedback links update' do
      expect(@feedback.resonance_value).to eq(2)
      @feedback.feedback_links.where(agree: true).first.update_attributes(agree: false)
      @feedback.reload
      expect(@feedback.resonance_value).to eq(1)
      @feedback.feedback_links.where(agree: true).first.update_attributes(agree: false)
      @feedback.reload
      expect(@feedback.resonance_value).to eq(0)
      @feedback.feedback_links.each{ |fl| fl.update_attributes(agree: false) }
      @feedback.reload
      expect(@feedback.resonance_value).to eq(0)
    end

    it 'has a resonance value of -1 if it is a personal feedback request' do
      request = FactoryGirl.create(:spec_full_feedback, user: @author, author: @author)
      expect(request.resonance_value).to eq(-1)
    end

    it 'cannot have the same peer assigned twice' do
      same_peer = @feedback.peers.first
      new_peer = FactoryGirl.create(:spec_user, email: 'new_peer@gmail.com')
      new_link = FeedbackLink.new(user: same_peer, feedback: @feedback)
      expect(new_link.save).to eq(false)
      new_link = FeedbackLink.new(user: new_peer, feedback: @feedback)
      expect(new_link.save).to eq(true)
    end

    it 'has a comment history including share logs' do
      @feedback.comments.update_all(created_at: 2.minutes.ago)
      new_user = FactoryGirl.create(:spec_user, email: "somenewpeer@gmail.com")
      @feedback.assign_peers([new_user.user_tag], @feedback.peers.first)
      FactoryGirl.create(:spec_comment, feedback: @feedback, user: new_user, created_at: 2.minutes.from_now)
      expect(@feedback.share_logs.count).to eq(1)
      expect(@feedback.comment_history.count).to eq(4)
      expect(@feedback.comment_history[2].class).to eq(ShareLog)
    end

    it 'sends an email to the recipient when resonance increases' do
      mail_count = ActionMailer::Base.deliveries.count
      @recipient = @feedback.user
      @recipient.mailer_settings.update_all(active?: true)
      @feedback.feedback_links.each{|link| link.update_attributes(agree: false)}
      @feedback.feedback_links.first.update_attributes(agree: true)
      expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
      @feedback.feedback_links.each{|link| link.update_attributes(agree: true)}
      expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 2)
    end

  end

end