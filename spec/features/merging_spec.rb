require 'rails_helper'

describe 'Merge feedback' do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @feedback1 = FactoryGirl.create(:spec_full_feedback, user: @user, content: "You suck!")
    @author2 = FactoryGirl.create(:spec_user, email: 'author2@gmail.com')
    @feedback2 = FactoryGirl.create(:spec_full_feedback, user: @user, author: @author2, content: "Man, you REALLY suck!")
    log_in_with(@user.email, 'password')
  end

  it 'has the merge action available for feedbacks you have received', js: true do
    feedback_personal = FactoryGirl.create(:spec_feedback, user: @user, author: @user)
    feedback_sent_from_me = FactoryGirl.create(:spec_feedback, user: @author2, author: @user)
    [feedback_personal, feedback_sent_from_me].each do |f|
      within("#feedback-#{f.id}"){ expect(page).to_not have_css('.action.merge') }
    end
    [@feedback1, @feedback2].each do |f|
      within("#feedback-#{f.id}"){ expect(page).to have_css('.action.merge') }
    end
  end

  # Scratch this -- drop in some of the model logic testing instead.
    # it 'by dragging a feedback by the merge icon and dropping into another feedback and confirming the modal'

end