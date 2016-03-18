require 'rails_helper'

describe 'Feedback', js: true do
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
    expect(page).to have_content('RESONANT')
    @feedback.feedback_links.first.update_attributes(agree: false)
    visit root_path
    expect(page).to have_content('MIXED')
    @feedback.feedback_links.each{|fl| fl.update_attributes(agree: false)}
    visit root_path
    expect(page).to have_content('ISOLATED')
  end

  it 'with score 1 of 3 should be isolated' do
    @feedback.feedback_links.first.destroy
    @feedback.feedback_links.first.update_attributes(agree: false)
    expect(@feedback.resonance_value).to eq(0)
  end

  it 'can have additional peers added via share button', js: true do
    @newpeer1 = FactoryGirl.create(:spec_user, email: 'newpeer1@gmail.com', first_name: 'new', last_name: 'peer')
    @newpeer2 = FactoryGirl.create(:spec_user, email: 'newpeer2@gmail.com', first_name: 'new', last_name: 'peer')
    peer_count = @feedback.peers.count
    visit current_path
    within "#feedback-#{@feedback.id}" do
      find('.action.share').click
    end
    within '#share-panel' do
      find('textarea').set "#{@newpeer1.user_tag}, #{@newpeer2.user_tag}"
      find('.share').click
    end
    sleep 2
    visit current_path
    @feedback.reload
    expect(@feedback.peers.count).to eq(peer_count + 2)
    within("#feedback-#{@feedback.id}") do
      expect(page).to have_css('.peers .number', text: peer_count + 3) # +1 for author
    end
  end

end