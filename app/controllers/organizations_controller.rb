class OrganizationsController < ApplicationController

  def get_users
    @organization = current_user.organization
    render json: {users: @organization.spreadsheet_data, managers: @organization.managers}.to_json
  end

  def update_user
    user = User.find(params[:id])
    user.update_attribute(params[:attribute].to_sym, params[:value])
    render text: params[:value]
  end

  def bulk_update
    manager = Manager.find(params[:manager_id])
    params[:user_ids].each do |id|
      u = User.find(id)
      mananger.add_employee(u)
    end
    render text: manager.full_name
  end

end