require 'will_paginate/array'

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :update_sanitized_params, if: :devise_controller?

  protect_from_forgery
#  include SessionsHelper

  add_flash_types :danger, :info, :warning, :success

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  #Stores pervious user url and reroutes user back after sign_in
  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.host == "thinqtv.herokuapp.com"
      @user = user_dashboard_path(current_user.permalink)
    else
      stored_location_for(resource_or_scope) || super
    end
  end

  protected

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:permalink, :name, :updating_password, :email, :password, :author, :password_confirmation, :remember_me])
  end

  def facebook_user
    @facebook_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :facebook_user



end
