class InvitesController < ApplicationController
	def index
		@invites = Invite.all
	end

  def create

      @invite = Invite.new(invite_params)

    if @invite.save
      flash[:success] = 'Rsvp was successfully created.'
      redirect_to fellowship_path
    else
      flash[:error] = 'Please enter a valid email address'
      redirect_back(fallback_location: root_path)
    end
  end

    private

  	def invite_params
    	params.require(:invite).permit(:firstname, :lastname, :description)
  	end 

end