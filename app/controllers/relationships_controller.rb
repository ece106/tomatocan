class RelationshipsController < ApplicationController

	def create
		user = User.find(params[:followed_id])
		current_user.follow(user)
		redirect_to user_profile_path(user.permalink)
	end

	def destroy
		user = Relationship.find(params[:id]).followed
		current_user.unfollow(user)
		redirect_to user_profile_path(user.permalink)
	end

end