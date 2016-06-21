module Slack
  class SlackController < ApplicationController

    before_filter :get_user, :verify_token

    def get_user
      @user = User.find_by_slack_id(params[:user_id])
    end

    def verify_token
      # TODO: hide this token in a secrets.yml file
      render status: 403 if param[:token] != "RfjYWFVlwCuHStlesUMT2Q4w"
    end

  end
end