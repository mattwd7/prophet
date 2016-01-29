class FeedbacksController < ApplicationController

  def create
    @errors = []
    @feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    unless @feedback.save
      @errors.push(@feedback.errors.full_messages)
    end
    @feedback.assign_peers(params[:peers].split(', ')) if params[:peers]
    @errors.flatten!
    respond_to{ |format| format.js }
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

  def share
    @feedback = Feedback.find(params[:id])
    @feedback.assign_peers(params[:additional_peers].split(', '))
    render text: @feedback.peers.count + 1
  end

end