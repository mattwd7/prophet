class CommentsController < ApplicationController

  def create
    @feedback = Feedback.find(params[:comment][:feedback_id])
    @comment = Comment.new(params.require(:comment).permit(:content, :feedback_id))
    @comment.user = current_user
    unless @comment.save
      flash[:error] = "Invalid Comment"
    end
    respond_to { |format| format.js }
  end

  def vote
    link = CommentLink.where(user: current_user, comment_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
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