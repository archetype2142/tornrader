module Api
  module V1
    class UsersController < Api::ApplicationController
      def index; end

      def create
        user = User.find_by(torn_user_id: params[:user])
        response = { message: "No user found", allowed: false }
        
        if user
          if !user&.subscriptions&.active.any?
            response = { message: "No active subscriptions found", allowed: false }
          else
            if user.trader_api_token_update_at 
              user.update!(
                trader_api_token: SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,""),
                trader_api_token_update_at: DateTime.now
              ) unless user.trader_api_token_update_at > 5.days.ago
              token = user.trader_api_token
            else
              token = SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
              user.update!(
                trader_api_token: token,
                trader_api_token_update_at: DateTime.now
              )
            end

            response = { 
              message: "Active subscription found!", 
              allowed: true, 
              token: token 
            }
          end
        end
        render json: response
      end
    end
  end
end
