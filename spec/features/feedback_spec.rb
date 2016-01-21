require 'rails_helper'

describe 'Feedback' do
  before(:each) do
    @feedback = FactoryGirl.create(:spec_full_feedback)
    @user = @feedback.user
    log_in_with(@user.email, 'password')
  end

  it 'displays the peer agreement numbers' do
    expect(page).to have_content(@feedback.peers_in_agreement.count + 1)
    expect(page).to have_content(@feedback.peers.count + 1)
  end

  it 'displays the appropriate flavor text' do
    expect(@feedback.peers_in_agreement.count).to eq(2)
    expect(@feedback.peers.count).to eq(3)
    expect(page).to have_content('MIXED')
    @feedback.feedback_links.each{|fl| fl.update_attributes(agree: true)}
    visit root_path
    expect(page).to have_content('RESONANT')
    @feedback.feedback_links.each{|fl| fl.update_attributes(agree: false)}
    visit root_path
    expect(page).to have_content('ISOLATED')
    @feedback.feedback_links.first.update_attributes(agree: true)
    visit root_path
    expect(page).to have_content('ISOLATED')
  end

  context 'with tags' do
    it 'lists its tags directly after its content' do
      tags = @feedback.tags.map(&:name)
      within('.feedback .top') do
        tags.each{|tag| expect(page).to have_content(tag) }
      end
    end

    it 'can have its tags clicked as a filter shortcut', js: true do
      @feedback2 = FactoryGirl.create(:spec_full_feedback, content: 'Another feedback', author: @feedback.author, user: @feedback.user)
      FactoryGirl.create(:spec_comment, content: "#tagcityson", feedback: @feedback2)
      visit current_path
      expect(page).to have_content(@feedback.content)
      expect(page).to have_content(@feedback2.content)
      find('.tag', text: '#tagcityson').click
      expect(page).to_not have_content(@feedback.content)
    end
  end

end