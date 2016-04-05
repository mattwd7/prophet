class FeedbacksController < ApplicationController

  def create
    @errors = []
    @feedback = Feedback.new(params.require(:feedback).permit(:author_id, :content))
    if @feedback.save
      @feedback.assign_peers(params[:peers].split(', ')) if params[:peers]
    else
      @errors.push(@feedback.errors.full_messages)
    end
    @errors.flatten!
    respond_to{ |format| format.js }
  end

  def vote
    link = FeedbackLink.where(user: current_user, feedback_id: params[:id]).first
    link.update_attributes(agree: params[:agree])
    render nothing: true
  end

  def share
    @feedback = Feedback.find(params[:id])
    @feedback.assign_peers(params[:additional_peers].split(', '), current_user)
    render text: @feedback.peers.count + 1
  end

  def destroy_notifications
    feedback = Feedback.find(params[:id])
    feedback.notifications.where(user: current_user).destroy_all
    render nothing: true
  end

  def peers_in_agreement
    @feedback = Feedback.find(params[:id])
    peers = autocomplete_attributes([@feedback.peers_in_agreement, @feedback.author].flatten)
    respond_to do |format|
      format.json { render json: peers.to_json }
    end
  end

  def peers
    @feedback = Feedback.find(params[:id])
    if params[:type] && params[:type] == 'Agree'
      peers = autocomplete_attributes([@feedback.peers_in_agreement, @feedback.author].flatten)
    else
      peers = autocomplete_attributes([@feedback.peers, @feedback.author].flatten)
    end
    respond_to do |format|
      format.json { render json: peers.to_json }
    end
  end

end