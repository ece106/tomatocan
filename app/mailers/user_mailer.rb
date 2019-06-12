class UserMailer < ApplicationMailer


  def welcome_email(user)
    @user = user
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end


  def password_reset(user)
    @user = user
    @url = user_changepassword_url(@user.permalink)
    mail(to: @user.email, subject: "Password Reset With Crowdpublish.TV")
  end
end

