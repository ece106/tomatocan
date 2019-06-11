class PasswordResetMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"

  def password_reset(user)
    @user = user
    @url = edit_user_password_url(host: 'crowdpublish.TV')
    mail(to: @user.email, subject: "Password Reset With Crowdpublish.TV")
  end
end
