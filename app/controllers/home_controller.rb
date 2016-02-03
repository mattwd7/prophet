class HomeController < ApplicationController

  def main
    if user_signed_in?
      redirect_to index_path
    end
  end

  def index
    @my_feedbacks = current_user.my_feedbacks
    @team_feedbacks = current_user.team_feedbacks
    @tags = current_user.my_tags
  end

  def recipients
    @recipients = autocomplete_attributes([current_user, current_user.peers].flatten)
    respond_to do |format|
      format.json { render json: @recipients.to_json }
    end
  end

  def peers
    @peers = autocomplete_attributes(current_user.peers)
    respond_to do |format|
      format.json { render json: @peers.to_json }
    end
  end

  def additional_peers
    @feedback = Feedback.find(params[:id])
    # TODO: optimize the following statement. Too many DB calls
    users = current_user.peers - @feedback.peers - [@feedback.author] - [@feedback.user]
    respond_to do |format|
      format.json { render json: autocomplete_attributes(users) }
    end
  end

  def filter_feedbacks
    my_feedbacks = current_user.my_feedbacks(params[:resonance], params[:attributes])
    team_feedbacks = current_user.team_feedbacks(params[:resonance], params[:attributes])
    render partial: 'feedbacks/index', locals: { my_feedbacks: my_feedbacks, team_feedbacks: team_feedbacks }
  end

private
  def autocomplete_attributes(users)
    users.map{|p| {user_tag: p.user_tag, avatar_url: p.avatar.url(:large), name: p.full_name, title: p.title}}
  end

end