class Api::V1::SessionsController < Api::V1::BaseApiController
    acts_as_token_authentication_handler_for User, fallback: :none
    before_action :ensure_params_exist
    def create
        #build_resource
        resource = User.find_for_database_authentication(:email=>params[:user][:email])
        return invalid_login_attempt unless resource

        if resource.valid_password?(params[:user][:password])
            sign_in resource, store: false
            renew_authentication_token(resource)
            render :json=> {:success=>true, :name=> resource.name, :token=>resource.authentication_token, :last_sign_in=>resource.last_sign_in_at, :current_sign_in=>resource.current_sign_in_at}
            return
        end
        invalid_login_attempt
    end

    def destroy
        use_rname = current_user.name
        sign_out(current_user)
        render :json=> {:success=>true, :name=>use_rname}
    end

    protected
    def ensure_params_exist
        return unless params.blank?
        render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end

    def invalid_login_attempt
        warden.custom_failure!
        render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
end