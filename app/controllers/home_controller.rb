class HomeController < ApplicationController

  def index
    if user_signed_in?
      @my_feedbacks = current_user.my_feedbacks
      @team_feedbacks = current_user.team_feedbacks
      @tags = current_user.my_tags
    else
      redirect_to new_user_session_path
    end
  end

  def recipients
    @recipients = typeahead_attributes([current_user, current_user.peers].flatten)
    respond_to do |format|
      format.json { render json: @recipients.to_json }
    end
  end

  def peers
    @peers = typeahead_attributes(current_user.peers)
    respond_to do |format|
      format.json { render json: @peers.to_json }
    end
  end

  def filter_feedbacks
    my_feedbacks = current_user.my_feedbacks(params[:resonance], params[:attributes])
    team_feedbacks = current_user.team_feedbacks(params[:resonance], params[:attributes])
    render partial: 'feedbacks/index', locals: { my_feedbacks: my_feedbacks, team_feedbacks: team_feedbacks }
  end

private
  def typeahead_attributes(users)
    users.map{|p| {user_tag: p.user_tag, avatar_url: p.avatar.url(:large), name: p.full_name, title: p.title}}
  end

end