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
    @feedbacks = current_user.home_feedbacks.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def impersonal_feedback_ids
    if current_user
      render json: current_user.home_feedbacks.map(&:id) - current_user.my_feedbacks.map(&:id)
    else
      render nothing: true
    end
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
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @feedbacks = @user.my_feedbacks(params[:resonance])
      all_user_feedbacks = @user.my_feedbacks
    elsif params[:manager].present? && current_user.is_a?(Manager)
      @feedbacks = current_user.employee_feedbacks(params[:resonance])
      all_user_feedbacks = @feedbacks
    else
      @feedbacks = current_user.home_feedbacks(params[:resonance])
      all_user_feedbacks = current_user.home_feedbacks
    end
    @feedbacks = @feedbacks.paginate(page: params[:page])
    html = render_to_string(partial: 'feedbacks/index', locals: { feedbacks: @feedbacks })
    resonances = { resonant: all_user_feedbacks.resonant.count.count, mixed: all_user_feedbacks.mixed.count.count, isolated: all_user_feedbacks.isolated.count.count }
    if params[:page]
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.json { render json: { feedbacks: html, resonances: resonances } }
      end
    end
  end

end