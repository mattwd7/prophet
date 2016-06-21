require 'rails_helper'

describe Slack::FeedbacksController do

  describe 'POST #create' do
    it 'defines the recipient'
    it 'prompts user for content'
  end

  describe 'POST #feedback_content' do
    it 'adds the feedback content'
    it 'prompts user for peers'
  end

  describe 'POST #feedback_peers' do
    it 'adds the peers and commits the feedback record'
    it 'notifies recipient of the feedback'
    it 'notifies peers of the feedback'
  end

  describe 'POST #feedback_agree' do
    it 'changes the users feedback_link agreement boolean'
    it 'notifies the user of the current agree count'
    it 'notifies the recipient of a change in resonance'
  end

  describe 'POST #comment_new' do

  end


end