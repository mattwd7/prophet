require 'rails_helper'

describe FeedbacksHelper do

  context 'hidden_comment_content' do
    before(:each) do
      @org = FactoryGirl.create(:spec_organization_full)
      @user = @org.users.first
      @author = @org.users.all[1]
      @feedback = FactoryGirl.create(:spec_feedback, user: @user, author: @author)
    end

    it 'will display first log and next 2 comments' do
      @feedback.create_peer_links(@org.users.all[2..5].map(&:user_tag), @author)
      2.times { FactoryGirl.create(:spec_comment, feedback: @feedback, user: @user) }

      arr = hidden_comment_content(@feedback, @user)
      hidden_count = arr.count{ |obj| obj[:hidden] }
      expect(hidden_count).to eq(0)
    end

    it 'will display all fresh comments for a user' do
      @feedback.create_peer_links(@org.users.all[2..5].map(&:user_tag), @author)
      2.times { FactoryGirl.create(:spec_comment, feedback: @feedback, user: @user) }

      4.times { FactoryGirl.create(:spec_comment, feedback: @feedback, user: @user) }
      peer = @feedback.peers.last
      arr = hidden_comment_content(@feedback, peer)
      hidden_count = arr.count{ |obj| obj[:hidden] }
      expect(hidden_count).to eq(0)
    end

    it 'will display fresh comments with mixed logs' do
      2.times { FactoryGirl.create(:spec_comment, feedback: @feedback, user: @user) }
      @feedback.create_peer_links(@org.users.all[2..5].map(&:user_tag), @author)
      2.times { FactoryGirl.create(:spec_comment, feedback: @feedback, user: @user) }
      peer = @feedback.peers.last

      arr = hidden_comment_content(@feedback, peer)
      hidden_count = arr.count{ |obj| obj[:hidden] }
      expect(hidden_count).to eq(0)
    end
  end


end