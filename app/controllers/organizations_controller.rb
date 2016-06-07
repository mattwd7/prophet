class OrganizationsController < ApplicationController

  before_filter :require_admin

  def get_users
    @organization = current_user.organization
    render json: {users: @organization.spreadsheet_data,
                  managers: @organization.managers.map{ |manager| manager.attributes.merge({full_name: manager.full_name}) }
                 }.to_json
  end

  def add_user
      @user = User.create(params.require(:user).permit(:first_name, :last_name, :email, :organization_id, :title))
      respond_to do |format|
        format.js
      end
  end

  def update_user
    user = User.find(params[:id])
    user.update_attribute(params[:attribute].to_sym, params[:value])
    render text: params[:value]
  end

  def update_managers
    successful_updates = []
    manager = Manager.find(params[:manager_id]) if params[:manager_id]
    params[:user_ids].each do |id|
      u = User.find(id)
      if manager && manager.add_employee(u)
        successful_updates << { user_id: u.id, managers: u.managers.map(&:full_name).join(', ') }
      else
        u.manager_employees.destroy_all
        successful_updates << { user_id: u.id, managers: '' }
      end
    end
    render json: { updates: successful_updates }.to_json
  end

  def update_user_role
    successful_update_ids = []
    params[:user_ids].each do |id|
      u = User.find(id)
      unless u == current_user # prevent Admin from reassigning self
        u.type =  params[:role]
        successful_update_ids.push(u.id) if u.save
      end
    end
    render json: { user_ids: successful_update_ids }.to_json
  end

end