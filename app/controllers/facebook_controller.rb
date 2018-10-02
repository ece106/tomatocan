class FacebookController < ActionController::Base
  
  def facebook_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def facebook_login

    @oauth= Koala::Facebook::OAuth.new(Koala.config.app_id, Koala.config.app_secret, "http:localhost:3000/facebook/callback")
  	@graph = Koala::Facebook::API.new("EAAHrK4Ygm48BAH6TloMo9oniAeTom6jluaXO2a0ZBLWkkaJLc5yHg6iFx6zAl6opqgVZA1hKrNIT295cQt6UFeZAhZCRMo7vzG7BFuonGXQ5yyixxVDHsTe5Pfg1GfZAFsR34WMSypxwrnivaQwnYI8jXzeposSL6ryFHnjKVItuxc3RL24hOhMS2Yxb2xZA8eEcQlPKXpgwZDZD")

  	#profile = @graph.get_object("me")
	  #friends = @graph.get_connections("me", "friends")
	  #@graph.put_connections("me", "feed", message: "I am writing on my wall!")
  end
end