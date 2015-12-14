class CommentsController < ApplicationController

  def create
    comment = Comment.new(params.require(:comment).permit(:content, :feedback_id))
    comment.user = current_user
    unless comment.save
      flash[:error] = "Invalid Comment"
    end
    redirect_to root_path
  end

  def vote
    link = CommentLink.where(user: current_user, comment_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

end