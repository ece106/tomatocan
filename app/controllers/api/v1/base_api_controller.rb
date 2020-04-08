class Api::V1::BaseApiController < ActionController::API
    respond_to :json
    def renew_authentication_token(resource)
        loop do
            token = Devise.friendly_token
            if not User.where(authentication_token: token).first
                resource.authentication_token = token
                break
            end
        end
        
    end
end