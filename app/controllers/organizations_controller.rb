class OrganizationsController < ApplicationController

  def get_users
    @organization = current_user.organization
    render json: @organization.users.to_json
  end

end