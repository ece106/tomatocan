require 'will_paginate/array'

class ApplicationController < ActionController::Base
  before_action :update_sanitized_params, if: :devise_controller?

  protect_from_forgery
#  include SessionsHelper

  add_flash_types :danger, :info, :warning, :success

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  def after_sign_in_path_for(resource)
      @user = user_profile_path(current_user.permalink)
  end


  protected

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:permalink, :name, :updating_password, :email, :password, :author, :password_confirmation, :remember_me, :address, :latitude, :longitude])
  end  

end
