require 'rails_helper'

describe 'Feedback filtering', js: true do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @author = FactoryGirl.create(:spec_user, email: "author@gmail.com")
    @resonant_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: "everyone agrees with me!")
    @mixed_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: 'people have mixed opinions on this one')
    @isolated_feedback = FactoryGirl.create(:spec_full_feedback, author: @author, user: @user, content: 'Im all alone on this one :(')
    @resonant_feedback.feedback_links.each{|fl| fl.update_attributes(agree: true) }
    @mixed_feedback.feedback_links.where(agree: true).first.update_attributes(agree: false)
    @isolated_feedback.feedback_links.each{|fl| fl.update_attributes(agree: false) }
    log_in_with(@user.email, 'password')
  end

  it 'narrows results based on resonance' do
    expect(page).to have_css('.feedback-summary .number-bubble', text: 1)
    expect(page).to have_content(@resonant_feedback.content)
    expect(page).to have_content(@mixed_feedback.content)
    expect(page).to have_content(@isolated_feedback.content)

    filter_resonance('resonant')
    expect(page).to have_css('.filter-tag', text: 'Resonant'.upcase)
    expect(page).to have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@mixed_feedback.content)
    expect(page).to_not have_content(@isolated_feedback.content)

    # multiple tags
    filter_resonance('mixed')
    expect(page).to have_css('.filter-tag', text: 'Mixed'.upcase)
    expect(page).to have_content(@mixed_feedback.content)
    expect(page).to have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@isolated_feedback.content)

    # remove a tag
    within('.filter-tag', text: 'Resonant'.upcase){ find('.delete').click }
    expect(page).to have_content(@mixed_feedback.content)
    expect(page).to_not have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@isolated_feedback.content)

    within('.filter-tag', text: 'Mixed'.upcase){ find('.delete').click }
    filter_resonance('isolated')
    expect(page).to have_css('.filter-tag', text: 'Isolated'.upcase)
    expect(page).to_not have_content(@resonant_feedback.content)
    expect(page).to_not have_content(@mixed_feedback.content)
    expect(page).to have_content(@isolated_feedback.content)
  end

  it 'narrows results based on both resonance and attributes'
  it 'expands results when you remove a filter tag'


end

def filter_resonance(resonance)
  find(".feedback-summary ##{resonance}").click
end

def filter_attribute(attribute)
  within('.attributes') do
    within('li', text: attribute){ find('.number-bubble').click }
  end
end