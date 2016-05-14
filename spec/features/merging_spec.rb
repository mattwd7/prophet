# require 'rails_helper'
# require 'merge_manager'
#
# describe 'Merge feedback' do
#   before(:each) do
#     @user = FactoryGirl.create(:spec_user)
#     @author1 = FactoryGirl.create(:spec_user, email: 'author1@gmail.com')
#     @feedback1 = FactoryGirl.create(:spec_full_feedback, user: @user, author: @author1, content: "You suck!")
#     @author2 = FactoryGirl.create(:spec_user, email: 'author2@gmail.com')
#     @feedback2 = FactoryGirl.create(:spec_full_feedback, user: @user, author: @author2, content: "Man, you REALLY suck!")
#     # 2 non-unique peers
#     FactoryGirl.create(:spec_feedback_link, feedback: @feedback2, user: @feedback1.peers.first)
#     FactoryGirl.create(:spec_feedback_link, feedback: @feedback2, user: @feedback1.peers.last)
#   end
#
#   it 'has the merge action available for feedbacks you have received', js: true do
#     feedback_personal = FactoryGirl.create(:spec_feedback, user: @user, author: @user)
#     feedback_sent_from_me = FactoryGirl.create(:spec_feedback, user: @author2, author: @user)
#     log_in_with(@user.email, 'password')
#     [feedback_personal, feedback_sent_from_me].each do |f|
#       within("#feedback-#{f.id}"){ expect(page).to_not have_css('.action.merge') }
#     end
#     [@feedback1, @feedback2].each do |f|
#       within("#feedback-#{f.id}"){ expect(page).to have_css('.action.merge') }
#     end
#   end
#
#   it 'replaces the merge-target feedback with the new, merged feedback', js: true do
#     @user.reload
#     expect(@user.feedbacks.count).to eq(2)
#     expect(@user.my_feedbacks.count.count).to eq(2)
#     log_in_with(@user.email, 'password')
#     feedback1_handle = find("#feedback-#{@feedback1.id} .action.merge")
#     expect(page).to have_css("#feedback-#{@feedback2.id} .top .content", count: 1)
#     feedback1_handle.drag_to find("#feedback-#{@feedback2.id} .top .content")
#     expect(page).to have_css('.modal#merge-confirmation')
#     within('#merge-confirmation'){ find('.submit-tag').click }
#     expect(page).to_not have_css("#feedback-#{@feedback1.id}")
#     expect(page).to_not have_css("#feedback-#{@feedback2.id}")
#     merged_feedback = @user.feedbacks.last
#     expect(page).to have_css("#feedback-#{merged_feedback.id}")
#     expect(page).to_not have_css('.modal#merge-confirmation')
#     within("#feedback-#{merged_feedback.id}") do
#       expect(page).to have_content('merged another feedback')
#     end
#   end
#
#   context 'after merge' do
#     before(:each) do
#       merger = MergeManager.new(@feedback1, @feedback2)
#       @merged_feedback = merger.merge
#     end
#
#     it 'combines unique peer links and corresponding agree counts' do
#       expect(@merged_feedback.peers.count).to eq(8)
#       expect(@merged_feedback.peers_in_agreement.count).to eq(6)
#     end
#
#     it 'combines comments' do
#       expect(@merged_feedback.comments.count).to eq(4)
#     end
#
#     it 'creates a merge log in the comments' do
#       expect(@merged_feedback.logs.count).to eq(1)
#     end
#
#     it 'no longer includes original feedbacks in query' do
#       expect(@user.feedbacks.count).to eq(1)
#       [@feedback1, @feedback2].each{|feedback| expect(@user.feedbacks).to_not include(feedback) }
#     end
#
#     it 'can be reverted by a sys admin'
#
#   end
#
# end