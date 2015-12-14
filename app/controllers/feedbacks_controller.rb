class FeedbacksController < ApplicationController

  def create
    feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    feedback.assign_peers(params[:peers])
    unless feedback.save
      flash[:error] = 'Must define a legitimate user tag.'
    end
    redirect_to root_path
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

end