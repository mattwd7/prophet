require 'rails_helper'

describe 'Manager', js: true do
  before(:each) do
    @manager = FactoryGirl.create(:spec_manager, type: 'Manager')
    @employee1 = FactoryGirl.create(:spec_user, email: 'employee1@gmail.com', first_name: 'employee', last_name: 'one')
    User.where(type: nil).each{|user| @manager.add_employee(user) }
    log_in_with(@manager.email, 'password')
  end

  it 'has the Manager tab in the banner' do
    within('#banner') do
      expect(page).to have_content('Manager')
    end
  end

  it 'does not display employees until clicking the Manager tab' do
    expect(page).to_not have_css('.employee')
    find('.sort .manager').click
    expect(page).to have_css('.employee')
  end

  context 'on the Manager tab' do
    before(:each) do
      @employee1 = FactoryGirl.create(:spec_user, email: 'employee1@gmail.com', first_name: 'employee', last_name: 'one')
      @employee2 = FactoryGirl.create(:spec_user, email: 'employee2@gmail.com', first_name: 'employee', last_name: 'two')
      @employee3 = FactoryGirl.create(:spec_user, email: 'employee3@gmail.com', first_name: 'employee', last_name: 'three')
      User.where(type: nil).each{|user| @manager.add_employee(user) }
      find('.sort .manager').click
    end

    it 'lists his employees' do
      expect(@manager.employees.count).to eq(3)
      expect(page).to have_css('.employee', count: 3)
      expect(page).to have_content(@employee1.full_name)
      expect(page).to have_content(@employee2.full_name)
      expect(page).to have_content(@employee3.full_name)
    end

    it 'can view an employees feedbacks' do
      @feedback = FactoryGirl.create(:spec_full_feedback, user: @employee2, content: 'This should show up. The others should not.')
      find('.employee', text: @employee1.full_name).click
      expect(page).to_not have_content(@feedback.content)
      find('.employee', text: @employee2.full_name).click
      expect(page).to have_content(@feedback.content)
    end

    it 'can filter employee feedbacks'

  end

end