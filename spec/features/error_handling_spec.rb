require 'rails_helper'

describe 'Feedback', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
    log_in_with(@author.email, 'password')
  end

  it 'displays error when no valid user is tagged' do
    within('.feedback-form') do
      find('#feedback_content').set "@DoesNotExist Where are you at?"
      find("#peers").set @user.user_tag
      find('.submit-tag').click
    end
    expect(page).to have_content("Feedback must designate a valid user tag.")
  end

  it 'displays error when no content is included' do
    within('.feedback-form') do
      find('#feedback_content').set "#{@recipient.user_tag}    \n\n\n   \n\n"
      find("#peers").set @user.user_tag
      find('.submit-tag').click
    end
    expect(page).to have_content("Feedback must have content.")
  end

  it 'displays warning when no peers are tagged'
end