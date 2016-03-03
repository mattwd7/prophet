class OrganizationsController < ApplicationController

  def get_users
    @organization = current_user.organization
    render json: @organization.spreadsheet_data.to_json
  end

  def update_user
    user = User.find(params[:id])
    user.update_attribute(params[:attribute].to_sym, params[:value])
    render text: params[:value]
  end
end