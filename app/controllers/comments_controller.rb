class CommentsController < ApplicationController

  def create
    @feedback = Feedback.find(params[:comment][:feedback_id])
    @comment = Comment.new(params.require(:comment).permit(:content, :feedback_id))
    @comment.user = current_user
    current_user.follow_up(@feedback) if @feedback.followed_up? && current_user.following_up?(@feedback)
    if @comment.save
      respond_to { |format| format.js }
    else
      render nothing: true
    end
  end

  def edit
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

end