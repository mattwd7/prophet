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

  def update_managers
    manager = Manager.find(params[:manager_id]) if params[:manager_id]
    params[:user_ids].each do |id|
      u = User.find(id)
      manager ? manager.add_employee(u) : u.manager_employees.destroy_all
    end
    render json: { manager: manager.try(:full_name) || '' }.to_json
  end

end