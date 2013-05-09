class SessionsController < ApplicationController

  def new
  end

  def create
    user ||= User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
 #     'Invalid email/password combination'
      render 'new'
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    sign_out
    redirect_to root_path
  end
end
