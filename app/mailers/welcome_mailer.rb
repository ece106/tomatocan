class WelcomeMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"
  @user = params(:user)

  def welcome_email
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end

end
