require 'rails_helper'

describe Log do
  before(:each) do
    @feedback = FactoryGirl.create(:spec_full_feedback)
    @user = FactoryGirl.create(:spec_user)
  end

  it 'creates content for share_log using names' do
    log = Log.create(type: "ShareLog", feedback: @feedback, user: @user, names: ['Jason Dick', 'Brian Dick'])
    expect(log.content).to_not be_nil
  end

end