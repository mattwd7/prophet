require 'rails_helper'

describe 'Feedback filtering', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author@gmail.com")
    @resonant_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: "everyone agrees with me!")
    @mixed_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: 'people have mixed opinions on this one')
    @isolated_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: 'Im all alone on this one :(')
    @resonant_feedback.feedback_links.each{|fl| fl.update_attributes(agree: true) }
    @mixed_feedback.feedback_links.where(agree: true).first.destroy
    @isolated_feedback.feedback_links.each{|fl| fl.update_attributes(agree: false) }
  end

  it 'narrows results based on resonance' do
    log_in_with(@user.email, 'secret')
    expect(page).to have_content(@resonant_feedback.content)
    expect(page).to have_content(@mixed_feedback.content)
    expect(page).to have_content(@isolated_feedback.content)

    filter('resonant')
    expect(page).to have_css('.filter-tag', text: 'Resonant'.upcase)
    expect(page).to have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@mixed_feedback.content)
    expect(page).to_not have_content(@isolated_feedback.content)

    filter('mixed')
    expect(page).to have_css('.filter-tag', text: 'Mixed'.upcase)
    expect(page).to_not have_content(@resonant_feedback.content)
    expect(page).to have_content(@mixed_feedback.content)
    expect(page).to_not have_content(@isolated_feedback.content)

    filter('isolated')
    expect(page).to have_css('.filter-tag', text: 'Isolated'.upcase)
    expect(page).to_not have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@mixed_feedback.content)
    expect(page).to have_content(@isolated_feedback.content)
  end

end

def filter(resonance)
  find(".feedback-summary ##{resonance}").click
end