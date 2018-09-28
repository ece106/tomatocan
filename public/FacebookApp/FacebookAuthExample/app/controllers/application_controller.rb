class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  	
  	@graph = Koala::Facebook::API.new(user.ouath_token)

  	profile = @graph.get_object("me")
	friends = @graph.get_connections("me", "friends")
	@graph.put_connections("me", "feed", message: "I am writing on my wall!")
  end
end
