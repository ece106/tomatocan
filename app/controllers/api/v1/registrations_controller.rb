class Api::V1::RegistrationsController < Api::V1::BaseApiController
    acts_as_token_authentication_handler_for User, fallback: :none
    def create
        def user_params
            params.require(:user).permit(:email, :name, :permalink, :password)
        end
        user = User.new(user_params)
        if user.save
            render :json=> {:success=>true, :name=>user.name, :token=>user.authentication_token}, :status=>201
            return
        else
            warden.custom_failure!
            render :json=> {:success=>false, :errors=>user.errors}, :status=>422
        end
    end
    def update 
        account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    
        # required for settings form to submit when password is left blank
        if account_update_params[:password].blank?
          account_update_params.delete("password")
          account_update_params.delete("password_confirmation")
        end
    
        @user = User.find(current_user.permalink)
        if @user.update_attributes(account_update_params)
          set_flash_message :notice, :updated
          # Sign in the user bypassing validation in case their password changed
          sign_in @user, :bypass => true
          redirect_to user_profile_path(current_user.permalink)
        else
          render user_profileinfo_path(current_user.permalink)
        end
      end
end