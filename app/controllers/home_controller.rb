class HomeController < ApplicationController

  def index
    if user_signed_in?
      @peers = current_user.peers
      @my_feedbacks = current_user.my_feedbacks
      @team_feedbacks = current_user.team_feedbacks
      @tags = current_user.my_tags
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

  def filter_feedbacks
    my_feedbacks = current_user.my_feedbacks(params[:resonance], params[:attributes])
    team_feedbacks = current_user.team_feedbacks(params[:resonance], params[:attributes])
    render partial: 'feedbacks/index', locals: { my_feedbacks: my_feedbacks, team_feedbacks: team_feedbacks }
  end

end