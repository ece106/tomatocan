class WelcomeMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"


  def welcome_email(user)
    @user = user
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end

end
