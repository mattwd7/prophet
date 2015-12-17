class HomeController < ApplicationController

  def index
    if user_signed_in?
      @peers = current_user.peers
      @my_feedbacks = Feedback.where("author_id = ? or user_id = ?", current_user.id, current_user.id).order('created_at DESC')
      @team_feedbacks = Feedback.where("author_id <> ? and user_id  <> ?", current_user.id, current_user.id).order('created_at DESC')
    else
      redirect_to new_user_session_path
    end
  end

  def peers
    @peers = current_user.peers.map{|p| p.attributes.select{|key, value| key.to_s == 'user_tag' }}
    respond_to do |format|
      format.json { render json: @peers.to_json }
    end
  end

end