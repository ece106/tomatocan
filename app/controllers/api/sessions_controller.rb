class Api::V1::SessionsController < Api::V1::BaseApiController
    before_action :ensure_params_exist
    def create
        resource = User.find_for_database_authentication(:email=>params[:user][:email])
        return invalid_login_attempt unless resource

        if resource.valid_password?(params[:user][:password]) || Devise.secure_compare(resource.authentication_token, params[:user][:token])
            sign_in resource, store: false
            renew_authentication_token(resource)
            render :json=> {:success=>true, :name=> resource.name, :token=>resource.authentication_token, 
                :permalink=>resource.permalink, :email=>resource.email, :id=>resource.id, :profpic=>current_user.profilepic, 
                :about=>current_user.about, :genre1=>current_user.genre1, :genre2=>current_user.genre2, :genre3=>current_user.genre3, 
                :bannerpic=>current_user.bannerpic}
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

    def after_sign_in_path_for(resource)
        if resource.is_a?(User) && resource.banned?
            sign_out resource
            flash[:error] = "This account has been banned"
            root_path
        else
            super
        end
    end

end