require 'rails_helper'

describe 'Admin', js: true do
  before(:each) do
    @org = FactoryGirl.create(:spec_organization_full)
    @admin = @org.admins.first
    log_in_with(@admin.email, 'password')
  end

  it 'has the Admin tab available' do
    within('.sort'){ expect(page).to have_content('Admin') }
  end

  context 'on admin tab' do
    before(:each) do
      find('.sort .admin').click
    end

    it 'sees all the members of his company' do
      @org.users.each{ |u| expect(page).to have_content(u.email) }
      @org.users.each{ |u| expect(page).to have_content(u.first_name) }
      @org.users.each{ |u| expect(page).to have_content(u.last_name) }
    end

    it 'can search on a manager name'
    it 'can change an employees first name'
    it 'can change an employees last name'
    it 'can assign a manager to an employee'

  end

end