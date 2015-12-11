class FeedbacksController < ApplicationController

  def create
    feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    feedback.assign_peers(params[:peers])
    unless feedback.save
      flash[:error] = 'Must define a legitimate user tag.'
    end
    redirect_to root_path
  end

end