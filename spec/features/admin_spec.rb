require 'rails_helper'

describe 'Admin', js: true do
  before(:each) do
    @org = FactoryGirl.create(:spec_organization_full)
    @admin = @org.admins.first
    @manager = FactoryGirl.create(:spec_manager, organization: @org)
    User.first(3).each{|u| @manager.add_employee(u)}
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

    it 'can search on a manager name' do
      within('#admin-grid_wrapper') do
        find('input').set @manager.first_name
        User.first(3).each{ |u| expect(page).to have_content(u.email) }
        User.all[3..9].each{ |u| expect(page).to_not have_content(u.email) }
      end
    end

    it 'can change an employees first name, last name, and email', no_webkit: true do
      within('#admin-grid_wrapper tbody') do
        all('td')[0].click
        find('input').set('charles')
        all('td')[1].click
        find('input').set('shaw')
        all('td')[2].click
        expect(page).to_not have_content('input')
        all('td')[3].click
        find('input').set('c.shaw@gmail.com')
        all('td')[4].click
        expect(page).to_not have_content('input')
        all('td')[5].click # commit last input
      end
      user_attributes = User.find_by_user_tag('@CharlesShaw').attributes.values
      ['Charles', 'Shaw', 'c.shaw@gmail.com'].each do |new_attribute|
        expect(user_attributes).to include(new_attribute)
      end
    end

    it 'can assign a manager to an employee'

  end

end