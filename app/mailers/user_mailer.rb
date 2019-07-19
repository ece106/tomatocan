class UserMailer < ApplicationMailer
 
  before_action do
    @user = params[:user]
  end

  before_action :set_url

  def welcome_email
    mail(to: @user.email, subject: "Welcome")
  end
  
  private

  def set_url
    @home_url = home_url(host: 'crowdpublish.TV')
    # if you need more url options you can use this method to expand
  end
end
