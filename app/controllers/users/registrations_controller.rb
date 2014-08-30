class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
    before_filter :update_sanitized_params, if: :devise_controller?

    def update_sanitized_params
       devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:permalink, :name, :updating_password, :email, :password, :about, :author, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, :twitter, :ustreamvid, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl, :youtube, :pinterest, :facebook, :address, :latitude, :longitude)}
    end

    def localauthorsscene
      build_resource({})
      respond_with self.resource
    end

end