class UserMailer < ApplicationMailer


  def welcome_email(user)
    @user = user
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end

end

