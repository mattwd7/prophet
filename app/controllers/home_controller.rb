class HomeController < ApplicationController

  def about; end
  def help; end
  def data; end
  def terms; end
  def privacy; end
  def careers; end

  def main
    redirect_to index_path if user_signed_in?
  end

  def index
    @my_feedbacks = current_user.my_feedbacks
    @team_feedbacks = current_user.team_feedbacks
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
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    all_my_feedbacks = @user.my_feedbacks
    my_feedbacks = @user.my_feedbacks(params[:resonance])
    if @user == current_user
      team_feedbacks = @user.team_feedbacks(params[:resonance])
      html = render_to_string(partial: 'feedbacks/index', locals: { my_feedbacks: my_feedbacks, team_feedbacks: team_feedbacks })
    else
      html = render_to_string(partial: 'feedbacks/my_feedbacks', locals: { my_feedbacks: my_feedbacks })
    end
    resonances = { resonant: all_my_feedbacks.resonant.count.count, mixed: all_my_feedbacks.mixed.count.count, isolated: all_my_feedbacks.isolated.count.count }
    respond_to do |format|
      format.json { render json: { feedbacks: html, resonances: resonances } }
    end
  end

private
  def autocomplete_attributes(users)
    users.map{|p| {user_tag: p.user_tag, avatar_url: p.avatar.url(:large), name: p.full_name, title: p.title}}
  end

end