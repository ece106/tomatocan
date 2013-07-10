class SessionsController < ApplicationController

  def new
  end

=begin
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
 #     flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
=end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    sign_out
    redirect_to root_path
  end
end
