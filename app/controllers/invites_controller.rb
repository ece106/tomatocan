class InvitesController < ApplicationController


  def create

      @invite = Invite.new(invite_params)

    if @invite.save
      flash[:success] = 'invite was successfully created.'
      redirect_to fellowship_path
    else
      flash[:error] = 'Please enter a valid first name'
      redirect_back(fallback_location: root_path)
    end
  end

    private

  	def invite_params
    	params.require(:invite).permit(:firstname, :lastname, :email, :description)
  	end 

end