class PasswordResetMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"

  def password_reset
    @url = user_changepassword_url(host: 'crowdpublish.TV')
    mail(to: :email, subject: "Password Reset With Crowdpublish.TV")
  end
end
