require 'rails_helper'

describe 'Feedback' do
  before(:each) do
    @feedback = FactoryGirl.create(:spec_full_feedback)
    @user = @feedback.user
    log_in_with(@user.email, 'password')
  end

  it 'displays the peer agreement numbers' do
    expect(page).to have_content(@feedback.peers_in_agreement.count)
    expect(page).to have_content(@feedback.peers.count)
  end

  it 'displays the number of comments' do
    expect(page).to have_content(@feedback.comments.count)
  end

  it 'displays the appropriate flavor text' do
    expect(page).to have_content('MEANINGFUL')
  end

  it 'can be commented on'

  context 'belonging to current_user' do
    it 'cannot be voted on'
  end

  context 'authored by current_user' do
    it 'cannot be voted on'

  end

  context 'available to a peer' do
    it 'can be voted on'

  end

end