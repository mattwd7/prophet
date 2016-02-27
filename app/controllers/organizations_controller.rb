class OrganizationsController < ApplicationController

  def get_users
    @organization = current_user.organization
    render json: @organization.spreadsheet_data.to_json
  end

end