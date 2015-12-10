require 'rails_helper'

describe 'User' do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
  end

  it 'signs into and out of his account' do
    visit root_path
    find('#user_email').set @user.email
    find('#user_password').set 'password'
    find('input[type=submit]').click
    expect(page).to have_content(@user.email)
    expect(page).to have_content('Sign Out')
    click_link 'Sign Out'
    expect(page).to have_css('#user_email')
  end

end