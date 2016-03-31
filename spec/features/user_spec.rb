require 'rails_helper'

describe 'User', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author1@gmail.com")
    @recipient = FactoryGirl.create(:spec_user, email: 'tony@gmail.com', first_name: 'Tony', last_name: 'Decino')
    log_in_with(@user.email, 'password')
  end

  context 'in settings' do

    it 'does not break javascript on returning to homepage' do
      expect(page).to have_content('Resonance')
      find('.session').click
      expect(page).to have_content('Edit Profile')
      within('#session-options'){ find('li', text: 'Edit Profile').click }
      expect(page).to have_content('Account')
      expect(page).to_not have_content('Team')
      find('.logo').click
      expect(page).to have_content('Resonance')
      find('.session').click
      expect(page).to have_content('Edit Profile')
    end

  end

end