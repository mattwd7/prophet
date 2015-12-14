class HomeController < ApplicationController

  def index
    if user_signed_in?
      @my_feedbacks = Feedback.where("author_id = ? or user_id = ?", current_user.id, current_user.id).order('created_at DESC')
      @all_feedbacks = Feedback.where("author_id <> ? and user_id  <> ?", current_user.id, current_user.id).order('created_at DESC')
    else
      redirect_to new_user_session_path
    end
  end

end