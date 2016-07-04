class UsersController < ApplicationController

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
      if permitted_params.keys.include?('password_confirmation') && !@user.valid_password?(params[:user][:current_password])
        flash[:error] = 'Invalid current password.'
        redirect_to edit_user_path and return
      end
      @user.assign_attributes(permitted_params)
      if @user.save
        @user.update_mailer_settings(params[:user]['mailer_settings'])
        @user.avatar.reprocess! if @user.cropping?
        sign_in @user, bypass: true
        flash[:notice] = "User successfully updated."
        redirect_to edit_user_path
      else
        flash[:error] = @user.errors.full_messages
        redirect_to edit_user_path
      end
    end
  end

private
  def permitted_params
    if params[:user][:password].blank?
      params.require(:user).permit(:email, :first_name, :last_name, :company, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    else
      params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token, :first_name, :last_name, :company, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end
  end

end