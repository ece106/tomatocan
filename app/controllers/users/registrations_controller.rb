class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
    before_filter :update_sanitized_params, if: :devise_controller?

    def update_sanitized_params
       devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:permalink, :name, :updating_password, :email, :password, :author, :password_confirmation, :remember_me, :address, :latitude, :longitude)}
    end

  def update    #I don't update registrations is at this point
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

    def profileinfo
      @user = User.find(current_user.permalink)
      build_resource(@user)
      respond_with self.resource
    end
  
    def localauthorsscene
      build_resource({})
      respond_with self.resource
    end

end