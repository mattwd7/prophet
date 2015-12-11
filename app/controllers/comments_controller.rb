class CommentsController < ApplicationController

  def create
    comment = Comment.new(params.require(:comment).permit(:content, :feedback_id))
    comment.user = current_user
    unless comment.save
      flash[:error] = "Invalid Comment"
    end
    redirect_to root_path
  end

end