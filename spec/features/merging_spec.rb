require 'rails_helper'

describe 'Merge feedback', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @feedback1 = FactoryGirl.create(:spec_full_feedback, user: @user, content: "You suck!")
    @feedback2 = FactoryGirl.create(:spec_full_feedback, user: @user, content: "Man, you REALLY suck!")
    log_in_with(@user.email, 'password')
  end

  it 'has the merge action available for feedbacks'
  it 'by dragging a feedback by the merge icon and dropping into another feedback and confirming the modal'

end