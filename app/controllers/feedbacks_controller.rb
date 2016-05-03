class FeedbacksController < ApplicationController

  def create
    @errors = []
    @feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    if @feedback.save
      @feedback.create_peer_links(params[:peers].split(', ')) if params[:peers]
    else
      @feedback.errors.each{ |attr, msg| @errors.push(msg) }
    end
    @errors.flatten!
    respond_to do |format|
      format.js
    end
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

  def share
    @feedback = Feedback.find(params[:id])
    @log = @feedback.create_peer_links(params[:additional_peers].split(', '), current_user)
    respond_to do |format|
      format.js
    end
  end

  def destroy_notifications
    feedback = Feedback.find(params[:id])
    personal_feedback = [feedback.user, feedback.author].include?(current_user)
    feedback.notifications.where(user: current_user).destroy_all
    respond_to do |format|
      format.json { render json: { me_feedback: personal_feedback }.to_json }
    end
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
    if params[:perform_merge]
      # @merged_feedback = Feedback.first
      @merged_feedback = MergeManager.new(@feedback_1, @feedback_2).merge
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