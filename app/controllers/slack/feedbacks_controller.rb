module Slack
  class FeedbackController < SlackController

    def index
      feedbacks = @user.my_feedbacks.last
      content = feedbacks.map(&:content)
      render json: { feedbacks: content }.to_json
    end

    def show
    end



  end
end