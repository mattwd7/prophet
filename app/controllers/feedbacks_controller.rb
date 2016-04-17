class FeedbacksController < ApplicationController

  def create
    @errors = []
    @feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    if @feedback.save
      @feedback.create_peer_links(params[:peers].split(', ')) if params[:peers]
    else
      @errors.push(@feedback.errors.full_messages)
    end
    @errors.flatten!
    respond_to do
      |format| format.js
    end
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

  def share
    @feedback = Feedback.find(params[:id])
    @share_log = @feedback.create_peer_links(params[:additional_peers].split(', '), current_user)
    respond_to do |format|
      format.js
    end
  end

  def destroy_notifications
    feedback = Feedback.find(params[:id])
    feedback.notifications.where(user: current_user).destroy_all
    render nothing: true
  end

  def peers_in_agreement
    @feedback = Feedback.find(params[:id])
    peers = autocomplete_attributes(@feedback.peers_in_agreement)
    respond_to do |format|
      format.json { render json: peers.to_json }
    end
  end

  def merge
    @feedback_1 = Feedback.find(params['feedback_1_id'])
    @feedback_2 = Feedback.find(params['feedback_2_id'])
    @perform_merge = params[:perform_merge]
    if @perform_merge
      # merge logic
    end
    respond_to do |format|
      format.js
    end
  end

  def peers
    @feedback = Feedback.find(params[:id])
    if params[:type] && params[:type] == 'Agree'
      peers = autocomplete_attributes(@feedback.peers_in_agreement)
    else
      peers = autocomplete_attributes(@feedback.peers)
    end
    respond_to do |format|
      format.json { render json: peers.to_json }
    end
  end

end