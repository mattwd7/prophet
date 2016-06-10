require 'rails_helper'

describe Comment do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @feedback = FactoryGirl.create(:spec_feedback, user: @user)
  end

  it 'has a valid factory' do
    @comment = FactoryGirl.build(:spec_comment)
    expect(@comment.save).to eq(true)
  end

  it 'must belong to a user and a feedback' do
    @comment = FactoryGirl.build(:spec_comment, content: "")
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, user: nil)
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, feedback: nil)
    expect(@comment.save).to eq(false)
    @comment = FactoryGirl.build(:spec_comment, content: "My Comment")
    result = @comment.save
    expect(result).to eq(true)
  end

  it 'sends an email to the feedback recipient' do
    @other_user = FactoryGirl.create(:spec_user, email: 'other_user@gmail.com')
    @user.mailer_settings.update_all(active: false)
    mail_count = ActionMailer::Base.deliveries.count
    FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
    expect(ActionMailer::Base.deliveries.count).to eq(mail_count)
    @user.mailer_settings.each{|ms| ms.update_attributes(active: true)}
    FactoryGirl.create(:spec_comment, user: @other_user, feedback: @feedback)
    expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
  end

end