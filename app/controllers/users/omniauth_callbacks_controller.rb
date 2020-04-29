<<<<<<< HEAD
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
			@user = User.from_omniauth(request.env["omniauth.auth"])

			if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
			set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
			else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
			end
	end

	def failure
			redirect_to root_path
	end
end
=======
# app/controller/users/omniauth_callbacks_controller.rb

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  
    def failure
      redirect_to root_path
    end
  end
>>>>>>> bc2b08d1601ccbd4987827af7ef4a7dc8ee6c47f
