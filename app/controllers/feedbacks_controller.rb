class FeedbacksController < ApplicationController

  def create
    @errors = []
    @feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    @feedback.assign_peers(params[:peers].split(', ')) if params[:peers]
    unless @feedback.save
      @errors.push(@feedback.errors.full_messages)
    end
    @errors.flatten!
    respond_to{ |format| format.js }
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

end