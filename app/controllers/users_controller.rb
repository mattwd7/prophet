class UsersController < ApplicationController

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(permitted_params)
    if @user.save
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to edit_user_path
    end
  end

private
  def permitted_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :avatar)
  end

end