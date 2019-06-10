class WelcomeMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"


  def welcome_email
    @user_name = :name
    @url = home_url(host:'crowdpublish.TV')
    mail(to: :email, subject: "Welcome")
  end

end
