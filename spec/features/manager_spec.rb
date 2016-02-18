require 'rails_helper'

describe 'Manager', js: true do
  before(:each) do
    @manager = FactoryGirl.create(:spec_manager, type: 'Manager')
    @employee1 = FactoryGirl.create(:spec_user, email: 'employee1@gmail.com', first_name: 'employee', last_name: 'one')
    @employee2 = FactoryGirl.create(:spec_user, email: 'employee2@gmail.com', first_name: 'employee', last_name: 'two')
    @employee3 = FactoryGirl.create(:spec_user, email: 'employee3@gmail.com', first_name: 'employee', last_name: 'three')
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
      @feedback1 = FactoryGirl.create(:spec_feedback, user: @employee2, content: 'Most resonant', resonance_value: 2)
      @feedback2 = FactoryGirl.create(:spec_feedback, user: @employee2, author: @feedback1.author, content: 'Something mixed', resonance_value: 1)
      @feedback3 = FactoryGirl.create(:spec_feedback, user: @employee2, author: @feedback1.author, content: 'Pretty well isolated', resonance_value: 0)
      find('.sort .manager').click
    end

    it 'prompts manager to choose an employee' do
      expect(page).to have_content('Select an employee to view feedbacks.')
    end

    it 'lists his employees' do
      expect(@manager.employees.count).to eq(3)
      expect(page).to have_css('.employee', count: 3)
      expect(page).to have_content(@employee1.full_name)
      expect(page).to have_content(@employee2.full_name)
      expect(page).to have_content(@employee3.full_name)
    end

    it 'can view an employees feedbacks' do
      feedback = FactoryGirl.create(:spec_full_feedback, user: @employee2, content: 'This should show up. The others should not.')
      find('li.employee', text: @employee1.full_name).click
      expect(page).to_not have_content(feedback.content)
      view_as(@employee2)
      expect(page).to have_content(feedback.content)
    end

    it 'updates the resonance values to reflect the target user' do
      # number-bubbles all at 0 because no feedback for manager
      all('.feedback-summary li .number-bubble').each do |number_bubble|
        expect(number_bubble.text).to eq('0')
      end
      view_as(@employee2)
      # number-bubbles update to reflect user being viewed
      expect(page).to have_content(@employee2.feedbacks.first.content)
      all('.feedback-summary li .number-bubble').each do |number_bubble|
        expect(number_bubble.text).to eq('1')
      end
      # reset all numbers back to manager's numbers
      find('.sort .me').click
      expect(page).to have_content('No feedback results found.')
      all('.feedback-summary li .number-bubble').each do |number_bubble|
        expect(number_bubble.text).to eq('0')
      end
    end

    it 'can filter employee feedbacks', no_webkit: true do
      expect(page).to_not have_content(@feedback1.content)
      expect(page).to_not have_content(@feedback2.content)
      expect(page).to_not have_content(@feedback3.content)

      view_as(@employee2)
      expect(page).to have_content(@feedback1.content)
      expect(page).to have_content(@feedback2.content)
      expect(page).to have_content(@feedback3.content)
      expect(page).to have_css('#viewing-as', text: @employee2.full_name)

      filter_resonance('resonant')
      expect(page).to have_content(@feedback1.content)
      expect(page).to_not have_content(@feedback2.content)
      expect(page).to_not have_content(@feedback3.content)
      filter_resonance('resonant') # toggle off
      filter_resonance('mixed')
      expect(page).to_not have_content(@feedback1.content)
      expect(page).to have_content(@feedback2.content)
      expect(page).to_not have_content(@feedback3.content)
      filter_resonance('mixed') # toggle off
      filter_resonance('isolated')
      expect(page).to_not have_content(@feedback1.content)
      expect(page).to_not have_content(@feedback2.content)
      expect(page).to have_content(@feedback3.content)
    end

  end

end

def view_as(user)
  find('li.employee', text: user.full_name).click
end