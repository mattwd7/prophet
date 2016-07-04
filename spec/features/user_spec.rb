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

    it 'can change email notification settings' do
      visit edit_user_path(@user)
      find('#settings-menu .notifications').click
      within('#middle') do
        expect(page).to have_content('Notifications')
        expect(page).to have_css('input[type="checkbox"]')
        all('input[type="checkbox"]:not(:checked)').each{|box| box.click }
        find('.submit-tag').click
      end
      expect(page).to have_css('#general')
      expect(@user.mailer_settings.map(&:active).count(true)).to eq(@user.mailer_settings.count)
    end

    it 'can change password' do
      visit edit_user_path(@user)
      fill_in "user[current_password]", with: 'wrong'
      fill_in "user[password]", with: 'new password'
      fill_in "user[password_confirmation]", with: 'new password'
      first('.submit-tag').click
      expect(page).to have_content("Invalid current password")

      fill_in "user[current_password]", with: 'password'
      fill_in "user[password]", with: 'new password'
      fill_in "user[password_confirmation]", with: 'new password'
      first('.submit-tag').click
      expect(page).to have_content("User successfully updated")

      fill_in "user[current_password]", with: 'password'
      fill_in "user[password]", with: 'new password'
      fill_in "user[password_confirmation]", with: 'new password'
      first('.submit-tag').click
      expect(page).to have_content("Invalid current password")
    end


  end

end