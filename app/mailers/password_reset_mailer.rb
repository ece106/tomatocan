class PasswordResetMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"

  def password_reset(user)
    @user = user
    @url = user_changepassword_url(@user.permalink)
    mail(to: @user.email, subject: "Password Reset With Crowdpublish.TV")
  end
end
