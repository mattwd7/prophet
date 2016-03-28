class UsersController < ApplicationController
  before_filter :hide_sorting

  def create
    @user = User.new(permitted_params)
    if @user.save
      redirect_to index_path
    else
      redirect_to root_path, error: @user.errors.full_messages
    end
  end

  def registration_request
    InternalMail.registration_request(params[:email]).deliver
    redirect_to root_path, notice: 'Thank you for your interest! We will contact you as soon as possible.'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if request.xhr?
      @user.update_attributes(bio: params[:value])
      render text: params[:value]
    else
      @user.assign_attributes(permitted_params)
      if @user.save
        @user.avatar.reprocess! if @user.cropping?
        redirect_to edit_user_path
      else
        flash[:error] = @user.errors.full_messages
        redirect_to edit_user_path
      end
    end
  end

private
  def permitted_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :company, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
  end

  def hide_sorting
    @hide_sorting = true
  end

end