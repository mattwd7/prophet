require 'rails_helper'
require 'merge_manager'

describe 'Merge feedback' do
  before(:each) do
    @user = FactoryGirl.create(:spec_user)
    @feedback1 = FactoryGirl.create(:spec_full_feedback, user: @user, content: "You suck!")
    @author2 = FactoryGirl.create(:spec_user, email: 'author2@gmail.com')
    @feedback2 = FactoryGirl.create(:spec_full_feedback, user: @user, author: @author2, content: "Man, you REALLY suck!")
    # 2 non-unique peers
    FactoryGirl.create(:spec_feedback_link, feedback: @feedback2, user: @feedback1.peers.first)
    FactoryGirl.create(:spec_feedback_link, feedback: @feedback2, user: @feedback1.peers.last)
  end

  it 'has the merge action available for feedbacks you have received', js: true do
    log_in_with(@user.email, 'password')
    feedback_personal = FactoryGirl.create(:spec_feedback, user: @user, author: @user)
    feedback_sent_from_me = FactoryGirl.create(:spec_feedback, user: @author2, author: @user)
    [feedback_personal, feedback_sent_from_me].each do |f|
      within("#feedback-#{f.id}"){ expect(page).to_not have_css('.action.merge') }
    end
    [@feedback1, @feedback2].each do |f|
      within("#feedback-#{f.id}"){ expect(page).to have_css('.action.merge') }
    end
  end

  context 'after merge' do
    before(:each) do
      merger = MergeManager.new(@feedback1, @feedback2)
      @merged_feedback = merger.merge
    end

    it 'combines unique peer links and corresponding agree counts' do
      expect(@merged_feedback.peers.count).to eq(8)
      expect(@merged_feedback.peers_in_agreement.count).to eq(6)
    end

    it 'combines comments' do
      expect(@merged_feedback.comments.count).to eq(4)
    end

    it 'creates a merge log in the comments' do
      expect(@merged_feedback.logs.count).to eq(1)
    end

    it 'no longer includes original feedbacks in query' do
      expect(@user.feedbacks.count).to eq(1)
      [@feedback1, @feedback2].each{|feedback| expect(@user.feedbacks).to_not include(feedback) }
    end

    it 'can be reverted by a sys admin'

  end

  # Scratch this -- drop in some of the model logic testing instead.
    # it 'by dragging a feedback by the merge icon and dropping into another feedback and confirming the modal'

end