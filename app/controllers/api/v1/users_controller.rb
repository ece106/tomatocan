class Api::V1::UsersController < Api::V1::BaseApiController
    acts_as_token_authentication_handler_for User, fallback: :none
    def index
        if current_user.nil?
            render json: { success: false }
        else
            render json: { success: true, auth_token: current_user.authentication_token, email: current_user.email }
        end
    end
end